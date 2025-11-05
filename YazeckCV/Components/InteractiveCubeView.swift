import SwiftUI
import SceneKit

struct InteractiveCubeView: UIViewRepresentable {
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var node: SCNNode?
        var material: SCNMaterial?
        
        // Escala
        var currentScale: CGFloat = 1.0
        let minScale: CGFloat = 0.4, maxScale: CGFloat = 2.5
        
        // Ciclo de figuras (para cuando quieras mutar de forma en otro gesto si lo deseas)
        enum ShapeKind: CaseIterable { case box, sphere, torus, capsule, cone, pyramid }
        var shapeIndex = 0
        
        // 🔵 Animación de color continua por HUE
        private var displayLink: CADisplayLink?
        private var lastTimestamp: CFTimeInterval = 0
        private var hue: CGFloat = 0.40       // punto de partida
        private let hueSpeed: CGFloat = 1/6.0 // vuelta completa en ~6s
        
        // MARK: - Setup/Teardown del color animado
        func startColorLoop() {
            stopColorLoop()
            displayLink = CADisplayLink(target: self, selector: #selector(stepColorLoop(_:)))
            displayLink?.add(to: .main, forMode: .common)
        }
        func stopColorLoop() {
            displayLink?.invalidate()
            displayLink = nil
        }
        @objc private func stepColorLoop(_ link: CADisplayLink) {
            guard let mat = material else { return }
            if lastTimestamp == 0 { lastTimestamp = link.timestamp; return }
            let dt = CGFloat(link.timestamp - lastTimestamp)
            lastTimestamp = link.timestamp
            
            hue += hueSpeed * dt
            if hue > 1 { hue -= 1 }
            // Saturación y brillo altos para look “neón”
            let ui = UIColor(hue: hue, saturation: 0.85, brightness: 0.95, alpha: 1.0)
            mat.diffuse.contents = ui
        }
        
        // MARK: - Gestos
        // Toque mínimo: invierte color y hace un “nudge”
        @objc func handleTouchDown(_ sender: UILongPressGestureRecognizer) {
            guard let node = node, let view = sender.view as? SCNView, let mat = material else { return }
            // Solo si empezó sobre la geometría (para no romper el scroll cuando tocas fuera)
            guard beganOnNode(sender, in: view) else { return }
            if sender.state == .began {
                // 1) Invertir color actual
                let current: UIColor = (mat.diffuse.contents as? UIColor) ?? .white
                do {
                    var r: CGFloat = 1, g: CGFloat = 1, b: CGFloat = 1, a: CGFloat = 1
                    current.getRed(&r, green: &g, blue: &b, alpha: &a)
                    let inv = UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: a)
                    mat.diffuse.contents = inv
                    // Sincroniza hue a la inversión (opcional)
                    var h: CGFloat = 0, s: CGFloat = 0, br: CGFloat = 0
                    if inv.getHue(&h, saturation: &s, brightness: &br, alpha: &a) { hue = h }
                }
                
                // 2) Nudge (empujoncito) visual
                let up = SCNAction.moveBy(x: 0, y: 0.12, z: 0, duration: 0.08)
                up.timingMode = .easeOut
                let down = SCNAction.moveBy(x: 0, y: -0.12, z: 0, duration: 0.10)
                down.timingMode = .easeIn
                let nudge = SCNAction.sequence([up, down])
                node.runAction(nudge)
            }
        }
        
        // Pan -> rotación libre X/Y (incremental)
        @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            guard let node = node, let v = sender.view else { return }
            let t = sender.translation(in: v)
            let dx = Float(t.x) * 0.014
            let dy = Float(t.y) * 0.014
            node.eulerAngles.y += dx
            node.eulerAngles.x -= dy
            sender.setTranslation(.zero, in: v)
        }
        
        // Pinch -> escala
        @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
            guard let node = node else { return }
            if sender.state == .changed {
                currentScale *= sender.scale
                currentScale = max(minScale, min(maxScale, currentScale))
                let s = Float(currentScale)
                node.scale = SCNVector3(s, s, s)
                sender.scale = 1.0
            }
        }
        
        // Rotation -> Z
        @objc func handleRotation(_ sender: UIRotationGestureRecognizer) {
            guard let node = node else { return }
            if sender.state == .changed {
                node.eulerAngles.z += Float(sender.rotation)
                sender.rotation = 0
            }
        }
        
        // MARK: - Hit test
        func beganOnNode(_ gesture: UIGestureRecognizer, in view: SCNView) -> Bool {
            let p = gesture.location(in: view)
            let hits = view.hitTest(p, options: [.boundingBoxOnly: false, .firstFoundOnly: true])
            guard let first = hits.first else { return false }
            return first.node == node || node?.childNodes.contains(first.node) == true
        }
        
        // MARK: - UIGestureRecognizerDelegate
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let view = gestureRecognizer.view as? SCNView else { return true }
            return beganOnNode(gestureRecognizer, in: view)
        }
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func dismantleUIView(_ uiView: SCNView, coordinator: Coordinator) {
        coordinator.stopColorLoop()
        coordinator.material = nil
        coordinator.node = nil
        uiView.scene = nil
    }
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = SCNScene()
        view.backgroundColor = .clear
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
        
        // Cámara
        let cam = SCNCamera(); cam.fieldOfView = 55
        let camNode = SCNNode(); camNode.camera = cam; camNode.position = SCNVector3(0, 0, 6)
        view.scene?.rootNode.addChildNode(camNode)
        
        // Luces
        func omni(_ pos: SCNVector3, intensity: CGFloat) -> SCNNode {
            let l = SCNLight(); l.type = .omni; l.intensity = intensity
            let n = SCNNode(); n.light = l; n.position = pos; return n
        }
        view.scene?.rootNode.addChildNode(omni(SCNVector3(6, 8, 10), intensity: 900))
        view.scene?.rootNode.addChildNode(omni(SCNVector3(-6, -8, -10), intensity: 550))
        let amb = SCNLight(); amb.type = .ambient; amb.intensity = 320; amb.color = UIColor(white: 1, alpha: 1)
        let ambNode = SCNNode(); ambNode.light = amb; view.scene?.rootNode.addChildNode(ambNode)
        
        // Geometría inicial (cubo)
        let box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0.18)
        let mat = SCNMaterial()
        mat.lightingModel = .physicallyBased
        mat.metalness.contents = 0.25
        mat.roughness.contents = 0.2
        box.materials = [mat]
        
        let node = SCNNode(geometry: box)
        view.scene?.rootNode.addChildNode(node)
        
        context.coordinator.node = node
        context.coordinator.material = mat
        context.coordinator.startColorLoop() // 🔵 comienza el ciclo de color
        
        // Gestos
        let touchDown = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTouchDown(_:)))
        touchDown.minimumPressDuration = 0
        touchDown.allowableMovement = 44
        
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        let rotation = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleRotation(_:)))
        
        [touchDown, pan, pinch, rotation].forEach {
            $0.delegate = context.coordinator
            $0.cancelsTouchesInView = false
            view.addGestureRecognizer($0)
        }
        
        // Hacer que el ScrollView espere a nuestros gestos si el toque cae sobre la figura
        DispatchQueue.main.async {
            if let scroll = view.enclosingScrollView() {
                scroll.panGestureRecognizer.require(toFail: pan)
                scroll.panGestureRecognizer.require(toFail: pinch)
                scroll.panGestureRecognizer.require(toFail: rotation)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) { }
}

// MARK: - Buscar UIScrollView ancestro
private extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var v: UIView? = self
        while let cur = v {
            if let s = cur as? UIScrollView { return s }
            v = cur.superview
        }
        return nil
    }
}

#Preview {
    ZStack {
        LiquidBackground()
        InteractiveCubeView()
            .frame(height: 240)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding()
    }
}



import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rippleView: UIView! {
        didSet {
            rippleView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        }
    }
    
    @IBOutlet var radar: CCMRadarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addRippleView()
    }
    
    
    var rippleEffectView: RippleEffectView!
    func addRippleView() {
        
        rippleEffectView = RippleEffectView(
            image: UIImage(named: ""),
            frame: rippleView.frame,
            didEnd: { success in
        })
        
        rippleView.addSubview(rippleEffectView!)
        rippleEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rippleEffectView.centerXAnchor.constraint(equalTo: rippleView.centerXAnchor),
            rippleEffectView.centerYAnchor.constraint(equalTo: rippleView.centerYAnchor),
            rippleEffectView.widthAnchor.constraint(equalTo: rippleView.widthAnchor),
            rippleEffectView.heightAnchor.constraint(equalTo: rippleView.heightAnchor)
            ])
        
        
        rippleEffectView?.setRippleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        rippleEffectView?.setRippleTrailColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.6))
        rippleEffectView?.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        rippleEffectView?.backgroundColor = .clear
        rippleEffectView?.titleLabel.textColor = .white
        rippleEffectView?.titleLabel.text = "Add\nGoal"
        rippleEffectView?.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }

}


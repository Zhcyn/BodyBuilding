import UIKit
class StartViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for imageView in [firstImageView, secondImageView, thirdImageView] {
            imageView?.image =
                UIImage(cgImage: (imageView?.image?.cgImage)!)
                    .withRenderingMode(.alwaysTemplate)
            imageView?.tintColor = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        getStartedButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.8078431373, blue: 0.368627451, alpha: 1)
        getStartedButton.layer.cornerRadius = 25
        getStartedButton.clipsToBounds = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func getStartedButtonClicked() {
    }
}

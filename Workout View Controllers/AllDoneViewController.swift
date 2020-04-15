import UIKit
class AllDoneViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    var workout: CompletedWorkout?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = workout?.workout.name
        navigationController?.navigationBar.topItem?.title = workout?.workout.name
        imageView?.image =
            UIImage(cgImage: (imageView?.image?.cgImage)!)
                .withRenderingMode(.alwaysOriginal)
        imageView?.tintColor = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        let timeInterval = Date().timeIntervalSince1970 - (workout?.startDate)!
        self.titleLabel.text = "You done"
        let h = Int(timeInterval / 3600)
        self.subtitleLabel.text = (h > 0 ? String(h) + "h " : "") + String(Int((Int(timeInterval) / 60) % 60)) + "m."
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func finishButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

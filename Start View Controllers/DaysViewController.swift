import UIKit
class DaysViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var sundayImageView: UIImageView!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var mondayImageView: UIImageView!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var tuesdayImageView: UIImageView!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var wednesdayImageView: UIImageView!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var thursdayImageView: UIImageView!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var fridayImageView: UIImageView!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var saturdayImageView: UIImageView!
    var imageViews: [UIImageView] = []
    var active = [0, 0, 0, 0, 0, 0, 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViews = [sundayImageView, mondayImageView, tuesdayImageView,
                      wednesdayImageView, thursdayImageView, fridayImageView,
                      saturdayImageView]
        nextButton.isEnabled = false
        nextButton.alpha = 0.3
        imageViews.forEach { (imageView) in
            imageView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
        }
        nextButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.8078431373, blue: 0.368627451, alpha: 1)
        nextButton.layer.cornerRadius = 25
        nextButton.clipsToBounds = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func dayClicked(sender: UIButton) {
        let index: Int!
        switch sender {
        case sundayButton:
            index = 0
            break
        case mondayButton:
            index = 1
            break
        case tuesdayButton:
            index = 2
            break
        case wednesdayButton:
            index = 3
            break
        case thursdayButton:
            index = 4
            break
        case fridayButton:
            index = 5
            break
        case saturdayButton:
            index = 6
            break
        default:
            index = 0
        }
        active[index] = active[index] == 0 ? 1 : 0
        var image: UIImage!
        if active[index] == 1 {
            image = UIImage(named: "checkmark_pressed")?.withRenderingMode(.alwaysOriginal)
        } else {
            image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
        }
        imageViews[index].image = image
        imageViews[index].frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        var activeCount = 0
        for a in active {
            if a == 1 {
                activeCount += 1
            }
        }
        if activeCount > 0 {
            nextButton.isEnabled = true
            UIView.animate(withDuration: 0.15) {
                self.nextButton.alpha = 1
            }
        } else {
            nextButton.isEnabled = false
            UIView.animate(withDuration: 0.15) {
                self.nextButton.alpha = 0.3
            }
        }
    }
    @IBAction func nextButtonClicked() {
        var gymDays: [DayOfWeek] = []
        for i in 0...active.count {
            switch i {
            case 0:
                gymDays.append(.Sunday)
                break
            case 1:
                gymDays.append(.Monday)
                break
            case 2:
                gymDays.append(.Tuesday)
                break
            case 3:
                gymDays.append(.Wednesday)
                break
            case 4:
                gymDays.append(.Thursday)
                break
            case 5:
                gymDays.append(.Friday)
                break
            case 6:
                gymDays.append(.Saturday)
                break
            default:
                return
            }
        }
        Workouts.setGymDays(gymDays)
    }
}

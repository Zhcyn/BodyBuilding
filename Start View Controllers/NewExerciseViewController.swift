import UIKit
class NewExerciseViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var useTimerLabel: UILabel!
    @IBOutlet weak var userTimerSwitch: UISwitch!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var minsLabel: UILabel!
    @IBOutlet weak var minsField: UITextField!
    @IBOutlet weak var repsStackView: UIStackView!
    @IBOutlet weak var minsStackView: UIStackView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var rootViewController: Exerciseable?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(NewExerciseViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewExerciseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        minsStackView.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.15) {
                self.stackViewBottomConstraint.constant = keyboardSize.height - 51
                self.stackViewBottom.setNeedsUpdateConstraints()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.15) {
            self.stackViewBottomConstraint.constant = 0
            self.stackViewBottom.setNeedsUpdateConstraints()
        }
    }
    @IBAction func swipe() {
        view.endEditing(true)
    }
    @IBAction func nextButtonClicked() {
        var exercise: Exercise!
        if userTimerSwitch.isOn {
            exercise = Exercise(name: nameField.text!, minutes: Int(minsField.text!) ?? 1)
        } else {
            exercise = Exercise(name: nameField.text!, reps: Int(repsField.text!) ?? 1)
        }
        rootViewController?.addExercise(exercise)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func timerSwitch() {
        if userTimerSwitch.isOn {
            minsStackView.isHidden = false
            repsStackView.isHidden = true
        } else {
            minsStackView.isHidden = true
            repsStackView.isHidden = false
        }
    }
    @IBAction func onDataChanged() {
        let name = nameField.text!
        let useTimer = userTimerSwitch.isOn
        var reps = Int(repsField.text!
            .components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined(separator: "")) ?? 0
        var mins = Int(minsField.text!
            .components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined(separator: "")) ?? 0
        if mins > 120 {
            mins = 120
        }
        if reps > 200 {
            reps = 200
        }
        if (useTimer && mins <= 0)
            || (!useTimer && (reps <= 0))
            || name.count == 0 {
            nextButton.isEnabled = false
            UIView.animate(withDuration: 0.15) {
                self.nextButton.alpha = 0.15
            }
        } else {
            nextButton.isEnabled = true
            UIView.animate(withDuration: 0.15) {
                self.nextButton.alpha = 1
            }
        }
        nameField.text = name
        repsField.text = String(reps)
        minsField.text = String(mins)
    }
}

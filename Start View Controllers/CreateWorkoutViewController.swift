import UIKit
class CreateWorkoutViewController: UIViewController, Exerciseable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var setNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var workoutNameView: UIView!
    var exercises: [Exercise] = []
    var dimissAfterCreate = false
    var callback: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if !dimissAfterCreate {
            cancelButton.isHidden = true
        }
        tableView.allowsSelection = true
        setButtonEnabled()
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        toolbar.barStyle = .blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CreateWorkoutViewController.doneButtonAction))
        doneBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        setNameField.inputAccessoryView = toolbar
        workoutNameView.layer.cornerRadius = 20
        setNameField.attributedPlaceholder = NSAttributedString(string: "My workout", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?()
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
        setButtonEnabled()
        tableView.reloadData()
    }
    @IBAction func swipe() {
        view.endEditing(true)
    }
    private func setButtonEnabled() {
        let name = setNameField.text!
        if name.count == 0 || exercises.count == 0 {
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
    }
    @IBAction func nameChanged() {
        setButtonEnabled()
    }
    @IBAction func nextButtonClicked() {
        Workouts.addWorkout(Workout(name: setNameField.text!, exercises: exercises))
        if dimissAfterCreate {
            dismiss(animated: true, completion: nil)
        } else {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "rootTabBarController")
                vc?.modalPresentationStyle = .fullScreen
                present(vc!, animated: true, completion: nil)
            } else {
                let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootTabBarController") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}
extension CreateWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == exercises.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExerciseTableViewCell
            let exercise = exercises[indexPath.row]
            cell.deleteImageView.image?.withRenderingMode(.alwaysTemplate)
            cell.deleteImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.deleteImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            cell.deleteImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            cell.titleLabel.text = exercise.name
            var subtitle: String!
            if exercise.useTimer {
                subtitle = String(exercise.minutes!) + " min" + (exercise.minutes! > 1 ? "s" : "")
            } else {
                subtitle = String(exercise.reps!) + " rep" + (exercise.reps! > 1 ? "s" : "")
            }
            cell.subtitleLabel.text = subtitle
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == exercises.count {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "newExerciseViewController") as! NewExerciseViewController
            viewController.rootViewController = self
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

import UIKit
class HistoryPreviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var workout: CompletedWorkout?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3725490196, green: 0.8078431373, blue: 0.368627451, alpha: 1)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension HistoryPreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout!.workout.exercises.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutTableViewCell
        let exercise = workout!.exercises[indexPath.row]
        cell.backView.layer.cornerRadius = 20
        cell.titleLabel.text = exercise.exercise.name
        cell.selectionStyle = .none
        var stepsString = [String]()
        for step in exercise.steps {
            if exercise.exercise.useTimer {
                stepsString.append(String(exercise.exercise.minutes!) + " mins")
            } else {
            }
        }
        guard let rep = exercise.exercise.reps else {return UITableViewCell()}
        cell.subtitleLabel.text = "repetitions: \(rep)"
        return cell
    }
}

import UIKit
class WorkoutPreviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    var workout: Workout?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = workout?.name
        tableView.allowsSelection = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if workout == nil {
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func nextButtonClicked() {
        let exercise = workout?.exercises.first
        if (exercise?.useTimer)! {
            let exerciseController = storyboard?.instantiateViewController(withIdentifier: "exerciseTimerViewController") as! ExerciseTimerViewController
            exerciseController.workout = CompletedWorkout(workout: workout!, startDate: Date().timeIntervalSince1970)
            exerciseController.exerciseNum = 0
            navigationController?.pushViewController(exerciseController, animated: true)
        } else {
            let exerciseController = storyboard?.instantiateViewController(withIdentifier: "exerciseRepsViewController") as! ExerciseRepsViewController
            exerciseController.workout = CompletedWorkout(workout: workout!, startDate: Date().timeIntervalSince1970)
            exerciseController.exerciseNum = 0
            navigationController?.pushViewController(exerciseController, animated: true)
        }
    }
    @IBAction func stopButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}
extension WorkoutPreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.exercises.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutTableViewCell
        let exercise = (workout?.exercises[indexPath.row])!
        var subtitle: String!
        if exercise.useTimer {
            subtitle = String(exercise.minutes!) + " min" + (exercise.minutes! > 1 ? "s" : "")
        } else {
            subtitle = String(exercise.reps!) + " rep" + (exercise.reps! > 1 ? "s" : "")
        }
        cell.titleLabel.text = exercise.name
        cell.subtitleLabel.text = subtitle
        cell.exerciseView.layer.cornerRadius = 20
        return cell
    }
}

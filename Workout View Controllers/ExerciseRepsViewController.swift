import UIKit
class ExerciseRepsViewController: UIViewController {
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var stepTextLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var measurementTextLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var workout: CompletedWorkout?
    var exerciseNum = 0
    var currentStep = 0
    var currentMeas = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        title = workout?.workout.name
        navigationController?.navigationBar.topItem?.title = workout?.workout.name
        let exercise = workout!.workout.exercises[exerciseNum]
        var subtitle: String!
        if exercise.useTimer {
            subtitle = String(exercise.minutes!) + " min" + (exercise.minutes! > 1 ? "s" : "")
        } else {
            subtitle = String(exercise.reps!) + " rep" + (exercise.reps! > 1 ? "s" : "")
        }
        currentMeas = Workouts.getLastMeasForExercise(exercise)
        titleLabel.text = exercise.name
        subtitleLabel.text = subtitle
        stepLabel.text = String(currentStep + 1)
        measurementTextLabel.text = "reps"
        measurementLabel.text = String(exercise.reps!)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func plusButtonClicked() {
        currentMeas += 1
    }
    @IBAction func minusButtonClicked() {
        currentMeas -= 1
    }
    @IBAction func nextButtonClicked() {
        let timerController = storyboard?.instantiateViewController(withIdentifier: "timerViewController") as! TimerViewController
        Workouts.setLastMeasForExercise(workout!.workout.exercises[exerciseNum], meas: currentMeas)
        if workout?.workout.exercises[exerciseNum].reps == currentStep + 1 {
            var completedExercise = workout!.exercises.last ?? CompletedExercise(exercise: (workout?.workout.exercises[exerciseNum])!)
            completedExercise.steps.append(currentMeas)
            if (workout?.exercises.count)! > 0 {
                workout?.exercises.removeLast()
            }
            workout?.exercises.append(completedExercise)
            if workout!.workout.exercises.count > exerciseNum + 1 {
                var completedExercises = workout!.exercises
                completedExercises.append(CompletedExercise(exercise: (workout?.workout.exercises[exerciseNum + 1])!))
                workout?.exercises = completedExercises
            }
            timerController.workout = workout
            timerController.exerciseNum = exerciseNum + 1
            timerController.exerciseStep = 0
        } else {
            var completedExercise = workout!.exercises.last ?? CompletedExercise(exercise: (workout?.workout.exercises[exerciseNum])!)
            completedExercise.steps.append(currentMeas)
            if (workout?.exercises.count)! > 0 {
                workout?.exercises.removeLast()
            }
            workout?.exercises.append(completedExercise)
            timerController.workout = workout
            timerController.exerciseNum = exerciseNum
            timerController.exerciseStep = currentStep + 1
        }
        navigationController?.pushViewController(timerController, animated: true)
    }
    @IBAction func stopButtonClicked() {
        let alert = UIAlertController(title: "Stop workout?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

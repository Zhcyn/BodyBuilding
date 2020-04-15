import UIKit
class ExerciseTimerViewController: UIViewController, CountdownTimerDelegate {
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var minsTextLabel: UILabel!
    @IBOutlet weak var minsLabel: UILabel!
    @IBOutlet weak var currentMinutesTextLabel: UILabel!
    @IBOutlet weak var currentSecondsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startTimerButton: UIButton!
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    var workout: CompletedWorkout?
    var exerciseNum = 0
    var currentStep = 0
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
        titleLabel.text = exercise.name
        subtitleLabel.text = subtitle
        minsTextLabel.text = "mins"
        minsLabel.text = String(exercise.minutes!)
        currentMinutesTextLabel.text = String(exercise.minutes!)
        currentSecondsLabel.text = ": " + String("00")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func startTimer() {
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: workout!.workout.exercises[exerciseNum].minutes!, seconds: 0)
        countdownTimer.start()
        startTimerButton.isHidden = true
    }
    func countdownTimerDone() {
        currentSecondsLabel.text = ""
        currentMinutesTextLabel.text = "Done"
    }
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        currentMinutesTextLabel.text = time.minutes
        currentSecondsLabel.text = ": " + time.seconds
    }
    @IBAction func nextButtonClicked() {
        let timerController = storyboard?.instantiateViewController(withIdentifier: "timerViewController") as! TimerViewController
        if workout?.workout.exercises[exerciseNum].reps == currentStep + 1 {
            var completedExercise = workout!.exercises.last ?? CompletedExercise(exercise: (workout?.workout.exercises[exerciseNum])!)
            completedExercise.steps.append(1)
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
            completedExercise.steps.append(1)
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

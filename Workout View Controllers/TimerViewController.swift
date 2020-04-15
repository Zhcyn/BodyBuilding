import UIKit
class TimerViewController: UIViewController, CountdownTimerDelegate {
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var progressView: ProgressBar!
    var workout: CompletedWorkout?
    var exerciseNum = 0
    var exerciseStep = 0
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgressBar(hours: 0, minutes: 0, seconds: 59)
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: 59)
        progressView.start()
        countdownTimer.delegate = self
        countdownTimer.start()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func skip() {
        countdownTimer.stop()
        progressView.stop()
        if workout!.workout.exercises.count == exerciseNum {
            let allDoneController = storyboard?.instantiateViewController(withIdentifier: "allDoneViewController") as! AllDoneViewController
            workout?.setEndDate(Date().timeIntervalSince1970)
            History.addWorkout(workout!)
            allDoneController.workout = workout
            navigationController?.pushViewController(allDoneController, animated: true)
            return
        }
        let exercise = workout!.workout.exercises[exerciseNum]
        if exercise.useTimer {
            let exerciseController = storyboard?.instantiateViewController(withIdentifier: "exerciseTimerViewController") as! ExerciseTimerViewController
            exerciseController.workout = workout
            exerciseController.exerciseNum = exerciseNum
            exerciseController.currentStep = exerciseStep
            navigationController?.pushViewController(exerciseController, animated: true)
        } else {
            let exerciseController = storyboard?.instantiateViewController(withIdentifier: "exerciseRepsViewController") as! ExerciseRepsViewController
            exerciseController.workout = workout
            exerciseController.exerciseNum = exerciseNum
            exerciseController.currentStep = exerciseStep
            navigationController?.pushViewController(exerciseController, animated: true)
        }
    }
    @IBAction func stopButtonClicked() {
        let alert = UIAlertController(title: "Stop workout?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func skipButtonClicked() {
        skip()
    }
    func countdownTimerDone() {
        skip()
    }
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        secondsLabel.text = String((Int(time.minutes) == 0 ? 1 : Int(time.minutes)!) * Int(time.seconds)!)
    }
}

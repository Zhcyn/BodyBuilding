import UIKit
class WorkoutsViewController: UIViewController {
    @IBOutlet weak var newWorkoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var workouts: [Workout] = []
    var callback: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    func reloadData() {
        workouts = Workouts.getWorkouts()
        tableView.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func newWorkoutButtonClicked() {
        let newWorkout = storyboard?.instantiateViewController(withIdentifier: "createWorkoutViewController") as! CreateWorkoutViewController
        let navigation = storyboard?.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        newWorkout.dimissAfterCreate = true
        newWorkout.callback = { [weak self] in
            self?.reloadData()
        }
        navigation.addChild(newWorkout)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
}
extension WorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutTableViewCell
        let workout = workouts[indexPath.row]
        var exercisesStringArray = [String]()
        for exercise in workout.exercises {
            exercisesStringArray.append(exercise.name.lowercased())
        }
        var exercisesString = exercisesStringArray.joined(separator: ", ")
        exercisesString = exercisesString.prefix(1).capitalized + exercisesString.dropFirst()
        cell.titleLabel.text = workout.name
        cell.subtitleLabel.text = exercisesString
        cell.backView.layer.cornerRadius = 20
        cell.clipsToBounds = true
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let workout = workouts[indexPath.row]
        let workoutPreviewNavigationController = storyboard?.instantiateViewController(withIdentifier: "workoutPreviewNavigationController") as! UINavigationController
        let workoutPreview = storyboard?.instantiateViewController(withIdentifier: "workoutPreviewViewController") as! WorkoutPreviewViewController
        workoutPreview.workout = workout
        workoutPreviewNavigationController.addChild(workoutPreview)
        workoutPreviewNavigationController.modalPresentationStyle = .fullScreen
        present(workoutPreviewNavigationController, animated: true, completion: nil)
    }
}

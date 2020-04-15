import UIKit
class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var workouts: [CompletedWorkout] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    func reloadData() {
        workouts = History.getWorkouts()
        tableView.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutTableViewCell
        let workout = workouts[indexPath.row]
        cell.backView.layer.cornerRadius = 20
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, h a"
        let date = Date(timeIntervalSince1970: workout.startDate)
        let interval = workout.endDate - workout.startDate
        let h = Int(interval / 3600)
        cell.titleLabel.text = dateFormatter.string(from: date)
        cell.subtitleLabel.text = "Taken break " + (h > 0 ? String(h) + "h " : "") + String(Int((Int(interval) / 60) % 60)) + "m."
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let workout = workouts[indexPath.row]
        let historyPreview = storyboard?.instantiateViewController(withIdentifier: "historyPreviewViewController") as! HistoryPreviewViewController
        historyPreview.workout = workout
        navigationController?.pushViewController(historyPreview, animated: true)
    }
}

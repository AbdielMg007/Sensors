import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var messageWait: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var isButtonActive = false
    var isButtonPause = false
    var timer: Timer?
    var remainingTime = 600
    var textAux = ""
    var titleNames = ["Configuracion", "Comentarios"]
    var images = ["settings", "feedback"]
    var sideBarOpen = true
    
    private let surfaceDetectionManager = SurfaceDetectionManager()
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func actionButton(_ sender: Any) {
        //boton de aceptar o cancelar
        startClock()
    }

    @IBAction func pauseActionButton(_ sender: Any) {
        //boton de pausar y reanudar
        pauseOrContinueButton()
    }

    @IBAction func buttonTappedSideBar(_ sender: Any) {
        //boton de la sidebar para ocultar o mostrar
        showSidebar()
    }
    
    func setup(){
        //Configuracion inicial
        messageWait.isHidden = true
        pauseButton.isHidden = true
        containerView.isHidden = true
        sideBarOpen = false
        registerTableCells()
        updateTimerLabel()
        motionManager.startDeviceMotionUpdates()
    }

    func registerTableCells() {
        //Llenar opciones de la sidebar
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }

    
    func updateTimerLabel() {
        //Mostrar el formato de horas pedido
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func startClock() {
        //se inicia el temporizador
        self.actionButton.backgroundColor = self.isButtonActive ? .orange : .red
        self.textAux = self.isButtonActive ? "Aceptar" : "Cancelar"
        self.actionButton.setTitle(self.textAux, for: .normal)
        self.isButtonActive = !isButtonActive
        
        if isButtonActive{
            validateSurface()
            surfaceDetectionManager.startSurfaceDetection()
        } else{
            messageWait.isHidden = true
            pauseButton.isHidden = true
            stopClock()
            surfaceDetectionManager.stopSurfaceDetection()
        }
    }
    
    func validateSurface(){
        //valida en tiempo real la posicion del iphone
        surfaceDetectionManager.surfaceStatusChanged = { [weak self] isFlat in
            DispatchQueue.main.async { [self] in
                if isFlat {
                    self?.pauseButton.isHidden = false
                    self?.messageWait.isHidden = true
                    self?.runClock()
                } else {
                    self?.pauseButton.isHidden = true
                    self?.messageWait.isHidden = false
                    self?.stopClock()
                }
                
            }
        }
    }

    func pauseOrContinueButton() {
        //pausar o continuar ya sabiendo que esta en vertical
        isButtonPause = !isButtonPause
        pauseButton.setTitle(isButtonPause ? "Reanudar" : "Pausar", for: .normal)
        if isButtonPause{
            stopClock()
        }else{
            runClock()
        }
    }
    
    func stopClock() {
        // Detener el reloj
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
    }

    func runClock() {
        // Iniciar o reanudar el reloj
        if isButtonPause == false{
            if timer == nil || !timer!.isValid {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
            }
        }
    }
    
    func showSidebar(){
        //ocultar o mostrar sidebar
        containerView.isHidden = false
        tableView.isHidden = false
        if !sideBarOpen{
            sideBarOpen = true
            containerView.frame = CGRect(x: 190, y: 103, width: 0, height: 829)
            tableView.frame = CGRect(x: 190, y: 103, width: 0, height: 829)
        }
        else{
            containerView.isHidden = true
            tableView.isHidden = true
            sideBarOpen = false
            containerView.frame = CGRect(x: 190, y: 103, width: 0, height: 829)
            tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 829)
        }
    }

    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Total de elementos el el tableview
        return titleNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //asignar imagen y etiqueta al tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.label.text = titleNames[indexPath.row]
        cell.imageIcon.image = UIImage(named: images[indexPath.row])
        cell.backgroundColor = .orange
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cambiar de pantalla al seleccionado
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "settings", sender: self)
        case 1:
            performSegue(withIdentifier: "feedback", sender: self)
        default:
            break
        }
    }
}

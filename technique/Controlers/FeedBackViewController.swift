//
//  FeedBackViewController.swift
//  technique
//
//  Created by Abdiel Mg on 24/07/23.
//

import UIKit

class FeedBackViewController: UIViewController {

    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        corner()
        setText()
    }
    
    func corner(){
        imagen.layer.cornerRadius = imagen.frame.height / 2
        imagen.clipsToBounds = true
    }
    
    func setText(){
        name.text = "Nombre: Abdiel Munoz Gonzalez"
        comments.text = "Comentarios:  \nLa aplicacion no se me hizo dificil como tal, mas que los tiempos de entrega y solo por algunos problemas y que ahorita lo estoy haciendo a contratiempo y dolor de cabeza, de ahi en fuera se me hizo una aplicacion entretenida de hacer y la verdad nunca se me habia ocurrido jugar con los sensores de el iPhone"
    }

}

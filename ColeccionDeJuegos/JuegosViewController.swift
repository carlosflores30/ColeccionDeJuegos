//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Roberto Flores on 30/09/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categorias.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoriaSeleccionada = categorias[row]
    }
    
    
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var elegirCategoria: UIPickerView!
    
    var imagePicker = UIImagePickerController()
    
    var juego:Juego? = nil
    var categoria: String? 
    
    var categorias: [String] = []
    var categoriaSeleccionada: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        elegirCategoria.delegate = self
        elegirCategoria.dataSource = self
        imagePicker.delegate = self
        
        cargarCategorias()
        
        if juego != nil{
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            categoriaSeleccionada = juego!.categoria // Obtener la categoría del juego
            configurarPickerView()
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        } else {
            
        }
    }
    
    func configurarPickerView() {
            if let categoria = categoriaSeleccionada, let index = categorias.firstIndex(of: categoria) {
                elegirCategoria.selectRow(index, inComponent: 0, animated: false)
            }
    }
    func cargarCategorias() {
        categorias = ["Paisajes", "Naturaleza", "Agricultura", "Plantas"]
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil{
            juego!.titulo! = tituloTextField.text!
            juego!.categoria = categoriaSeleccionada
            juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.categoria = categoriaSeleccionada
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

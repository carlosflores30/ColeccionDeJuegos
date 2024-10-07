//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by Roberto Flores on 30/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.isEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let juegoAEliminar = juegos[indexPath.row]
                juegos.remove(at: indexPath.row)
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(juegoAEliminar)
                do {
                    try context.save()
                } catch {
                    print("Error al eliminar el juego de Core Data")
                }
            tableView.reloadData()
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let juegoMovido = juegos.remove(at: sourceIndexPath.row)
            juegos.insert(juegoMovido, at: destinationIndexPath.row)
        }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JuegoCell", for: indexPath)
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        if let categoria = juego.categoria, !categoria.isEmpty {
            cell.detailTextLabel?.text = "Categoria: \(categoria)"
            } else {
                cell.detailTextLabel?.text = nil
            }
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        if let juegoSeleccionado = sender as? Juego {
                siguienteVC.juego = juegoSeleccionado
                siguienteVC.categoria = juegoSeleccionado.categoria 
            }
    }

}


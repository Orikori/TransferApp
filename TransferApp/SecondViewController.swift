//
//  SecondViewController.swift
//  TransferApp
//
//  Created by Дмитрий Артемьев on 27.12.2021.
//

import UIKit

protocol UpdatingDataController: AnyObject {
    var updatingData: String { get set }
}

class SecondViewController: UIViewController, UpdatingDataController {
    @IBOutlet var dataTextField: UITextField!
    
    var handleUpdatedDataDelegate: DataUpdateProtocol?
    var updatingData: String = ""
    
    var completionHandler: ((String) -> Void)?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTextFieldData(withText: updatingData)
    }
    // обновляем данные в текстовом поле
    private func updateTextFieldData(withText text: String) {
        dataTextField.text = text
        
    }
    
    @IBAction func saveDataWithProperty(_ sender: UIButton) {
        self.navigationController?.viewControllers.forEach {
            viewController in
            (viewController as? UpdatableDataController)?.updatedData = dataTextField.text ?? ""
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // определяем идентификатор segue
        switch segue.identifier {
        case "toFirstScreen":
            // обрабатываем переход
            prepareFirstScreen(segue)
        default:
            break
            
        }
    }
    
    // подготовка к переходу на первый экран
    private func prepareFirstScreen(_ segue: UIStoryboardSegue) {
        // безопасно извлекаем опциональное значение
        guard let destinationController = segue.destination as? ViewController else {
            return
            
        }
        destinationController.updatedData = dataTextField.text ?? ""
        
    }
    
    // Переход от Б к А
    // Передача данных с помощью делегата
    @IBAction func saveDataWithDelegate (_ sender: UIButton) {
        // получаем обновленные данные
        let updatedData = dataTextField.text ?? "" // вызываем метод делегата
        handleUpdatedDataDelegate?.onDataUpdate(data: updatedData) // возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveDataWithClosure(_ sender: UIButton) {
        // получаем обновленные данные
        let updatedData = dataTextField.text ?? ""
        // вызваем замыкание
        completionHandler?(updatedData)
        // возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
    
}

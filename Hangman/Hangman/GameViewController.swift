//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var guessField: UITextField!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    var wordProgress = [String()]
    var incorrects = [String()]
    var phrase = String()
    var numIncorrect = 0
    // create the alert
    let failAlert = UIAlertController(title: "Sorry!", message: "You have lost :(", preferredStyle: UIAlertControllerStyle.alert)
    let successAlert = UIAlertController(title: "Congrats!", message: "You have won! :)", preferredStyle: UIAlertControllerStyle.alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        // add an action (button)
        //alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: nil))
        failAlert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.cancel, handler: { action in
            
            // do something like...
            self.setup()
        }))
        successAlert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.cancel, handler:
            { action in
                
            self.setup()
                
        }))
    }
    
    func setup() {
        wordProgress = []
        incorrects = []
        phrase = ""
        numIncorrect = 0
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print("phrase")
        print(phrase)
        for c in phrase.characters {
            if c == " " {
                wordProgress += [" "]
            } else {
                wordProgress += ["_"]
            }
            wordProgress += [" "]
        }
        var displayText = String()
        for s in wordProgress {
            displayText += s
        }
        guessField.delegate = self
        word.text = displayText
        guessField.text = ""
        incorrectGuesses.text = "Incorrect Guesses:"
        image.image = UIImage(named: "hangman1.gif")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 1
        let currentString: NSString = NSString(string: textField.text!)
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func guessUpdate(_ sender: UIButton) {
        print("updating")
        print(wordProgress)
        var letter = guessField.text
        letter = letter!.uppercased()
        var i = 0
        // var found = false
        var incorrect = true
        for c in phrase.characters {
            if letter == String(c) {
                wordProgress[i] = letter!
                incorrect = false
            }
            i += 2
        }
        //print(wordProgress)
        var gameOver = false
        if incorrect {
            incorrects += [letter!]
            numIncorrect += 1
            let num = numIncorrect + 1
            let imageName = "hangman" + String(num) + ".gif"
            image.image = UIImage(named: imageName)
            if numIncorrect > 5 {
                print("game over")
                gameOver = true
                // show the alert
                self.present(failAlert, animated: true, completion: nil)
            }
        }
        
        //check if won
        var won = true
        if !gameOver {
            var displayWord = String()
            var displayWrong = String()
            for c in wordProgress {
                displayWord += c
                if "_" == String(c) {
                    won = false
                }
            }
            displayWrong += "Incorrect Guesses: "
            for c in incorrects {
                displayWrong += c
                displayWrong += " "
            }
            incorrectGuesses.text = displayWrong
            word.text = displayWord
        }
        if won {
            self.present(successAlert, animated: true, completion: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

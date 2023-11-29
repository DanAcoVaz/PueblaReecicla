//
//  FAQTableViewCell.swift
//  PueblaReecicla
//
//  Created by David Bo on 28/11/23.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    static let identifier = "FAQTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FAQTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    
    var isTapped = true
    
    func configure(with Question: Question) {
        questionLbl.text = Question.title
        answerLbl.text = Question.answer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isTapped == false {
            isTapped = true
            arrowBtn.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            answerLbl.isHidden = false
        } else {
            isTapped = false
            arrowBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            answerLbl.isHidden = true
        }
        
    }
    */
}

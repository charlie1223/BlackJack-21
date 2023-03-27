//
//  ViewController.swift
//  BJ21
//
//  Created by 邱奕軒 on 2023/1/14.
//

import UIKit

class ViewController: UIViewController {
    //playerA B Card
    @IBOutlet var playerACardImageViews: [UIView]!
    @IBOutlet var playerBCardImageViews: [UIView]!
    //PlayerA Suit&Rank
    @IBOutlet var cardsRankALabels: [UILabel]!
    @IBOutlet var cardsSuitA1Labels: [UILabel]!
    @IBOutlet var cardsSuitA2Labels: [UILabel]!
    //PlayerB Suit&Rank
    @IBOutlet var cardsRankBLabels: [UILabel]!
    @IBOutlet var cardsSuitB1Labels: [UILabel]!
    @IBOutlet var cardsSuitB2Labels: [UILabel]!
    //卡片點數
    @IBOutlet var cardsTotalLabels: [UILabel]!
    //賭金
    @IBOutlet weak var totalBetAmountLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    
    @IBOutlet weak var betSegment: UISegmentedControl!
    //賭金＋− Btn
    
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var cards = [Card]()
    var playerACards = [Card]()
    var playerBCards = [Card]()
    
    var index = 1
    var aCardPoint = 0
    var bCardPoint = 0
    var aSum = 0
    var bSum = 0
    var takeCard = Int.random(in: 0...51)
    
    var betAmount = 0
    var totalBetAmount = 100
    
    var controller = UIAlertController()
    var action = UIAlertAction()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //生成52卡牌
        for rank in ranks {
            for suit in suits {
                let card = Card()
                card.rank = rank
                card.suit = suit
                cards.append(card)
            }
        }
        gameInit()
        
        //卡牌UIView加入邊框＆邊框色＆底色
        for i in 0...4 {
            playerACardImageViews[i].layer.borderWidth = 0.5
            playerACardImageViews[i].layer.borderColor = UIColor.black.cgColor
            playerACardImageViews[i].backgroundColor = UIColor.white
            playerBCardImageViews[i].layer.borderWidth = 0.5
            playerBCardImageViews[i].layer.borderColor = UIColor.black.cgColor
            playerBCardImageViews[i].backgroundColor = UIColor.white
        }
    }
    
    //遊戲初始
    func  gameInit() {
        playerACards = [Card]()
        playerBCards = [Card]()
        
        index = 1
        aCardPoint = 0
        bCardPoint = 0
        aSum = 0
        bSum = 0
        betAmount = 0
        cardsTotalLabels[0].textColor = UIColor.black
        cardsTotalLabels[1].textColor = UIColor.black
        
        betSegment.selectedSegmentIndex = 0
        totalBetAmountLabel.text = "$\(totalBetAmount)"
        betLabel.text = "$\(betAmount)"
        
        //使卡牌imageView顯示兩張，並抽兩張牌
        for i in 0...4 {
            if i < 2 {
                playerACardImageViews[i].isHidden = false
                playerBCardImageViews[i].isHidden = false
                cards.shuffle()
                playerACards.append(cards[i])
                cards.shuffle()
                playerBCards.append(cards[i])
                cardsRankALabels[i].text = playerACards[i].rank
                cardsSuitA1Labels[i].text = playerACards[i].suit
                cardsSuitA2Labels[i].text = playerACards[i].suit
                cardsRankBLabels[i].text = playerBCards[i].rank
                cardsSuitB1Labels[i].text = playerBCards[i].suit
                cardsSuitB2Labels[i].text = playerBCards[i].suit
            }else{
                playerACardImageViews[i].isHidden = true
                playerBCardImageViews[i].isHidden = true
            }
        }
        //算兩張卡牌點數總和
        for i in 0...1 {
            aCardPoint = calculateRankNumber(card: playerACards[i])
            bCardPoint = calculateRankNumber(card: playerBCards[i])
            aSum = aSum + aCardPoint
            bSum = bSum + bCardPoint
        }
        cardsTotalLabels[0].text = "\(aSum)"
        cardsTotalLabels[1].text = "\(bSum)"
    }
    
    //定義rank相對應之Int
    func calculateRankNumber(card: Card) ->Int {
        var cardRankNumber = 0
        switch card.rank{
        case "A":
            cardRankNumber = 1
        case "J","Q","K":
            cardRankNumber = 10
        default:
            cardRankNumber = Int(card.rank)!
        }
        return cardRankNumber
    }
    
    @IBAction func betAmountCalculate(_ sender: UIButton) {
        if betSegment.selectedSegmentIndex == 0 {
            if sender == minusBtn {
                betAmount = betAmount - 1
            }else{
                betAmount = betAmount + 1
            }
        }else if betSegment.selectedSegmentIndex == 1 {
            if sender == minusBtn {
                betAmount = betAmount - 5
            }else{
                betAmount = betAmount + 5
            }
        }else{
            if sender == minusBtn {
                betAmount = betAmount - 10
            }else{
                betAmount = betAmount + 10
            }
        }
        //當欲出賭注金額小於零，皆為零（欲出賭金不為負數）/ 單場欲出賭金不得超出持有賭金
        if betAmount < 0 {
            betAmount = 0
        }else if betAmount > totalBetAmount {
            betAmount = totalBetAmount
        }
        betLabel.text = "$\(betAmount)"
    }
        
        
        //控制我方抽牌，及判斷輸贏
        
    @IBAction func getACard(_ sender: UIButton) {
        //亂數（隨機抽一張牌),index控制牌的張數
        takeCard = Int.random(in: 0...51)
        index = index + 1
        //每點選一次，抽一張牌
        playerBCardImageViews[index].isHidden = false
        playerBCards.append(cards[takeCard])
        cardsRankBLabels[index].text = playerBCards[index].rank
        cardsSuitB1Labels[index].text = playerBCards[index].suit
        cardsSuitB2Labels[index].text = playerBCards[index].suit
        
        //playerB: 我方卡牌點數總數
        bCardPoint = calculateRankNumber(card: playerBCards[index])
        bSum = bSum + bCardPoint
        cardsTotalLabels[1].text = "\(bSum)"
        
        //當我方卡牌超過21點
        if bSum > 21 {
            //totalBetAmountLabel.text = "$\(totalBetAmount)"
            totalBetAmount = totalBetAmount-betAmount
            totalBetAmountLabel.text = "$\(totalBetAmount)"
            
            cardsTotalLabels[1].textColor = UIColor.red
            //當我方卡牌超過21點：持有賭金為零時，遊戲重新開始
            if totalBetAmount <= 0 {
                betAmount = 0
                betLabel.text = "$\(betAmount)"
                totalBetAmountLabel.text = "$\(totalBetAmount)"
                controller = UIAlertController(title: "Game Over!", message: "\(bSum) Burst!\nOpps!\nYour bet amount is \(betAmount)!", preferredStyle: .alert)
                action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                    self.gameInit()
                }
                totalBetAmount = 100
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            //當我方卡牌超過21點：持有賭金不是零時，扣掉欲出賭金，繼續下一局
            }else{
                controller = UIAlertController(title: "Burst!", message: "BetAmount - \(betAmount)", preferredStyle: .alert)
                action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }
            
        //我方卡牌BlackJack!! 我方獲勝，持有賭金加上欲出賭金
        }else if bSum == 21 {
            totalBetAmountLabel.text = "$\(totalBetAmount)"
            totalBetAmount = totalBetAmount+betAmount
            cardsTotalLabels[1].textColor = UIColor.red
            controller = UIAlertController(title: "BLACKJACK!", message: "🤙🏻🤙🏻🤙🏻\nBetAmount + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
            
        //我方卡牌過五關 我方獲勝，持有賭金加上欲出賭金
        }else if bSum <= 21, index == 4 {
            cardsTotalLabels[1].textColor = UIColor.red
            totalBetAmountLabel.text = "$\(totalBetAmount)"
            totalBetAmount = totalBetAmount+betAmount
            
            controller = UIAlertController(title: "Five Card Charlie!", message: "BetAmount + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
    }
    
    }
    //判斷敵方抽牌與否，及判斷輸贏
    
    @IBAction func showCards(_ sender: UIButton) {
        
        //當敵方卡牌點數小於等於16時抽牌
        if aSum <= 16 {
            //抽牌迴圈，如敵方卡點數小於17時繼續抽牌，算出卡牌總點數
            for i in 2...4{
                if aSum <= 17 {
                    takeCard = Int.random(in: 0...51)
                    playerACardImageViews[i].isHidden = false
                    playerACards.append(cards[takeCard])
                    cardsRankALabels[i].text = playerACards[i].rank
                    cardsSuitA1Labels[i].text = playerACards[i].suit
                    cardsSuitA2Labels[i].text = playerACards[i].suit
                    aCardPoint = calculateRankNumber(card: playerACards[i])
                    aSum = aSum + aCardPoint
                }
            }
        }
        cardsTotalLabels[0].text = "\(aSum)"
        
        //判斷輸贏 Ａ敵方 Ｂ我方
        // 當 A > B 時， 有可能會遇到 a>21, a=21, a過五關, a=b, a<b, a>b
        if aSum > bSum {
            cardsTotalLabels[0].textColor = UIColor.red
            
            //a方點數超過21，a方輸 b方持有賭金加上欲出賭金
            if aSum > 21 {
                totalBetAmount = totalBetAmount+betAmount
                print("aSum > 21, total:\(totalBetAmount)")
                controller = UIAlertController(title: "YOU WIN!", message: "🤙🏻🤙🏻🤙🏻\nComputer: \(aSum) Busted!\nBetAmount + \(betAmount)", preferredStyle: .alert)
                action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
                
            //a方BlackJack，a方贏
            }else if aSum == 21 {
                totalBetAmountLabel.text = "$\(totalBetAmount)"
                totalBetAmount = totalBetAmount - betAmount
                cardsTotalLabels[0].textColor = UIColor.red
                //當a方卡牌超過21點：b方持有賭金為零時，遊戲重新開始
                if totalBetAmount <= 0  {
                    print("a方BlackJack，餘額0")
                    totalBetAmountLabel.text = "$\(totalBetAmount)"
                    betAmount = 0
                    betLabel.text = "$\(betAmount)"
                    controller = UIAlertController(title: "Game Over!", message: "Computer: BlackJack!\nOpps!\nYour bet amount is \(betAmount)!", preferredStyle: .alert)
                    action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                    totalBetAmount = 100
                //當a方卡牌超過21點：b方持有賭金不是零時，扣掉欲出賭金，繼續下一局
                }else{
                    print("a方BlackJack")
                    controller = UIAlertController(title: "YOU LOSE!", message: "Computer: BlackJack!\nBetAmount - \(betAmount)", preferredStyle: .alert)
                    action = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                }
            //a方過五關，a贏
            }else if aSum <= 21, playerACards.count == 5 {
                totalBetAmountLabel.text = "$\(totalBetAmount)"
                totalBetAmount = totalBetAmount - betAmount
                cardsTotalLabels[0].textColor = UIColor.red
                //當a方卡牌過五關：b方持有賭金為零時，遊戲重新開始
                if totalBetAmount <= 0 {
                    print("a方過五關，餘額0")
                    totalBetAmountLabel.text = "$\(totalBetAmount)"
                    betAmount = 0
                    betLabel.text = "$\(betAmount)"
                    controller = UIAlertController(title: "Game Over!", message: "Computer: Five Card Charlie!\nOpps!\nYour bet amount is \(betAmount)!", preferredStyle: .alert)
                    action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                    totalBetAmount = 100
                //當a方卡牌過五關：b方持有賭金不是零時，扣掉欲出賭金，繼續下一局
                }else{
                    print("a方過五關")
                    controller = UIAlertController(title: "YOU LOSE!", message: "Computer: Five Card Charlie!\nBetAmount - \(betAmount)", preferredStyle: .alert)
                    action = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                }
                
            //a>b，a贏
            }else if aSum > bSum {
                totalBetAmountLabel.text = "$\(totalBetAmount)"
                totalBetAmount = totalBetAmount-betAmount
                cardsTotalLabels[0].textColor = UIColor.red
                
                //當a>b：b方持有賭金為零時，遊戲重新開始
                if totalBetAmount <= 0 {
                    print("aSum > bSum，餘額0")
                    totalBetAmountLabel.text = "$\(totalBetAmount)"
                    betAmount = 0
                    betLabel.text = "$\(betAmount)"
                    controller = UIAlertController(title: "Game Over!", message: "Computer: \(aSum)>\(bSum)\nOpps!\nYour bet amount is \(betAmount)!", preferredStyle: .alert)
                    action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                        self.gameInit()
                    }
                    totalBetAmount = 100
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                    
                //當a>b：b方持有賭金不是零時，扣掉欲出賭金，繼續下一局
                }else{
                    print("aSum > bSum")
                    controller = UIAlertController(title: "YOU LOSE!", message: "BetAmount - \(betAmount)", preferredStyle: .alert)
                    action = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                }
            }
            
        //a=b，平手
        }else if aSum == bSum {
            print("aSum == bSum")
            cardsTotalLabels[0].textColor = UIColor.red
            cardsTotalLabels[1].textColor = UIColor.red
            controller = UIAlertController(title: "TIE GAME!", message: "", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            totalBetAmountLabel.text = "$\(totalBetAmount)"
            
        //a<b，a方輸 b方持有賭金加上欲出賭金
        }else if aSum < bSum {
            print("aSum < bSum")
            totalBetAmount = totalBetAmount+betAmount
            cardsTotalLabels[1].textColor = UIColor.red
            
            controller = UIAlertController(title: "YOU WIN!", message: "🤙🏻🤙🏻🤙🏻\nComputer: \(aSum) < \(bSum)\nBetAmount + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            totalBetAmountLabel.text = "$\(totalBetAmount)"
            
        }
    }
    }
    
        
    

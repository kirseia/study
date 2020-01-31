import UIKit
import FlexLayout
import PinLayout

class TestView: UIView {
    let rootContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        make()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func make() {
        addSubview(rootContainerView)
        
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        let moreButton = UIButton()
        moreButton.setTitle("More", for: .normal)
        moreButton.setTitleColor(.white, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        let playerView = UIView()
        playerView.backgroundColor = UIColor.red
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.text = "If you became wind"
        titleLabel.textColor = .white
        
        let nameLikesLabel = UILabel()
        nameLikesLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        nameLikesLabel.textColor = UIColor.white
        nameLikesLabel.text = "antonv · 803 likes"
        nameLikesLabel.alpha = 0.6
        
        let durationMediaCountLabel = UILabel()
        durationMediaCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        durationMediaCountLabel.textColor = UIColor.white
        durationMediaCountLabel.text = "00:31, 5 medias"
        durationMediaCountLabel.alpha = 0.6
        
        let useButton = UIButton()
        useButton.setTitle("Use Now", for: .normal)
        useButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        useButton.setTitleColor(.white, for: .normal)
        useButton.backgroundColor = UIColor.blue
        
        let lilkeButton = UIButton()
        lilkeButton.layer.cornerRadius = 2.0
        lilkeButton.setTitle("Like", for: .normal)
        lilkeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        lilkeButton.setTitleColor(.white, for: .normal)
        lilkeButton.backgroundColor = UIColor.gray
        
        // direction 은 기본 방향, (column 이 default 인데 위에서 아래로 내려가는 방향)
        rootContainerView.flex.direction(.column).define { (flex) in
            
            // 상단 back button / more button
            flex.addItem().direction(.row).justifyContent(.spaceBetween).height(50).define { (flex) in
                flex.addItem(backButton).marginLeft(8)
                flex.addItem(moreButton).marginRight(8)
            }
            
            // player layer
            flex.addItem().justifyContent(.center).define { (flex) in
                flex.addItem(playerView).aspectRatio(1.0)
            }.grow(1)
            
            // bottom container
            flex.addItem().height(172).direction(.column).padding(8, 24, 18, 24).define { (flex) in
                // title
                flex.addItem(titleLabel).height(29).marginBottom(4)
                
                // description (user, likes)
                flex.addItem(nameLikesLabel).height(14).marginBottom(21)
                
                // description (duration, medias)
                flex.addItem(durationMediaCountLabel).height(15).marginBottom(12)
                
                // use button, like button
                flex.addItem().direction(.row).define { (flex) in
                    flex.addItem(useButton).grow(1).marginRight(4)
                    
                    flex.addItem(lilkeButton).width(50)
                    
                }.height(50)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootContainerView.pin.all(safeAreaInsets)
        rootContainerView.flex.layout(mode: .fitContainer)
    }
}

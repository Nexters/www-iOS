//
//  LargeButton.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/07.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import UIKit
import SnapKit

/// LargeButton : 기본으로 사용되는 검정 버튼
/// - init(state isEnabled: Bool ) : 선택사항이며, 버튼 비활성 여부 결정 가능
/// - .setTitle("다음", for: .normal) : 버튼 이름 설정
///
/// 버튼 높이 및 양옆 마진을 잡아서 사용해주세요
/// ```
/// // 버튼 속성 예시
/// private lazy var nextButton: LargeButton(state: true)
/// nextButton.setTitle("다음", for: .normal)
/// nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
///
/// // 레이아웃 예시
/// $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
/// $0.leading.trailing.equalToSuperview().inset(20)
/// ```
///
final class LargeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    init(state isEnabled : Bool) {
        super.init(frame: .zero)
        setUI()
        setButtonState(isEnabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else { return }
        // TODO: 폰트 적용
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15, weight: .medium)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedString, for: state)
    }
    
    func setButtonState(_ isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        backgroundColor = isEnabled ? .black : .systemGray2
    }
    
}

extension LargeButton {
    
    private func setUI() {
        configuration = .plain()
        configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        tintColor = .white
        backgroundColor = .black
        clipsToBounds = true
        layer.cornerRadius = 26 // height/2
        
        snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}

// NewsFeedController.swift
// By Artem Golovanev

import Combine
import Core
import Design
import UIKit

final class NewsFeedController: UIViewController {
    let contentView: NewsFeedView
    let viewModel: NewsFeedViewModel

    private let appearanceStore: AppearanceStore
    private var bag = Set<AnyCancellable>()

    init(
        contentView: NewsFeedView,
        viewModel: NewsFeedViewModel,
        appearanceStore: AppearanceStore
    ) {
        self.contentView = contentView
        self.viewModel = viewModel
        self.appearanceStore = appearanceStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bag = bind()
        bindAppearance()
        viewModel.send(.loadMore)
    }
}

private extension NewsFeedController {
    func setupUI() {
        title = Strings.feedTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem()
    }
    
    func bindAppearance() {
        appearanceStore
            .publisher
            .sink { [weak self] appearance in
                self?.updateAppearanceButton(with: appearance)
            }
            .store(in: &bag)
    }

    func updateAppearanceButton(with selected: Appearance) {
        navigationItem.rightBarButtonItem?.image = selected.image
        navigationItem.rightBarButtonItem?.menu = UIMenu(
            title: Strings.appearanceTitle,
            options: .displayAsPalette,
            children: makeChildern(with: selected)
        )
    }
    
    func makeChildern(with selected: Appearance) -> [UIAction] {
        Appearance
            .allCases
            .map { appearance in
            UIAction(
                title: appearance.title,
                image: appearance.image,
                state: appearance == selected ? .on : .off
            ) { [weak self] _ in
                self?.appearanceStore.current = appearance
            }
        }
    }
}

extension NewsFeedController: Controller {}

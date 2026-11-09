// NewsDetailController.swift
// By Artem Golovanev

import Combine
import Core
import UIKit

final class NewsDetailController: UIViewController {
    let contentView: NewsDetailView
    let viewModel: NewsDetailViewModel

    private var bag = Set<AnyCancellable>()

    init(contentView: NewsDetailView, viewModel: NewsDetailViewModel) {
        self.contentView = contentView
        self.viewModel = viewModel
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
        viewModel.send(.load)
    }
}

private extension NewsDetailController {
    func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension NewsDetailController: Controller {}

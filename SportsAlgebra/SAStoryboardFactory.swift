//
//  SAStoryboardFactory.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    enum Storyboard: String {
        case main
        case news
        case gallery
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = Bundle.main) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

class SAStoryboardFactory {
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        let storyboard = UIStoryboard.storyboard(storyboard: .main)
        return storyboard.instantiateViewController()
    }
    
    func presentFirstViewController(in navigationController: UINavigationController?) {
        if PFUser.current()?.hasTakenFirstQuiz == false {
            SAStoryboardFactory().presentFirstQuizViewController(in: navigationController)
        } else {
            SAStoryboardFactory().presentHomeViewController(in: navigationController)
        }
    }
    
    func presentFirstQuizViewController(in navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }
        
        let vc: QuizViewController = self.instantiateViewController()
        let context = QuizContext(timePerQuestion: 120.0)
        context.isFirstQuiz = true
        vc.context = context
        vc.viewModel = QuizViewModel(quiz: FirstQuizGenerator.firstQuiz,
                                     context: context)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentHomeViewController(in navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }
        
        guard let user = PFUser.current() else {
            // TODO: Log out user since session is invalid
            SALog("Current User is nil. Logging out")
            return
        }
        
        let vc: HomeViewController = self.instantiateViewController()
        vc.viewModel = HomeViewModel(user: user)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentOnboarding(in navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }
        
        let vc: OnboardingViewController = self.instantiateViewController()
        vc.viewModel = OnboardingViewModel()
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func presentQuizPrefaceViewController(in navigationController: UINavigationController?, with quiz: Quiz) {
        guard let navigationController = navigationController else {
            return
        }
        
        let vc: QuizPrefaceViewController = self.instantiateViewController()
        vc.quiz = quiz
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentQuizViewController(in navigationController: UINavigationController?, with quiz: Quiz) {
        guard let navigationController = navigationController else {
            return
        }
        
        let vc: QuizViewController = self.instantiateViewController()
        let context = QuizContext(timePerQuestion: 120.0)
        vc.context = context
        vc.viewModel = QuizViewModel(quiz: quiz,
                                     context: context)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentQuizPreviewController(in presentingViewController: UIViewController, with quiz: Quiz, previewIndex: Int, userAnswer: Answer) {
        guard previewIndex < quiz.questions.count else {
            SALog("Preview index is out of bounds")
            return
        }
        
        let vc: QuizViewController = self.instantiateViewController()
        let context = QuizContext(timePerQuestion: 120.0, previewMode: true)
        vc.context = context
        let viewModel = QuizViewModel(quiz: quiz,
                                      context: context,
                                      questionIndex: previewIndex)
        viewModel.userAnswer = userAnswer
        vc.viewModel = viewModel
        vc.previewIndex = previewIndex
        presentingViewController.present(vc, animated: true)
    }
    
    func presentQuizResultsViewController(in navigationController: UINavigationController?, with quizResults: QuizResults) {
        guard let navigationController = navigationController else {
            return
        }
        
        let vc: QuizResultsViewController = self.instantiateViewController()
        vc.viewModel = QuizResultsViewModel(quizResults: quizResults)
        navigationController.pushViewController(vc, animated: true)
        
    }
}

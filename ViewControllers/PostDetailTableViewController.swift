//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Chris Grayston on 2/12/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var photoImageView: UIImageView!
  
  //MARK: - Properties
  var post: Post?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  
    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else { return }
        PostController.shared.fetchComments(for: post) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Methods
    @objc func updateViews() {
        guard let post = post else { return }
        photoImageView.image = post.photo
        tableView.reloadData()
        //updateFollowPostButtonText()
    }
  
  func presentCommentAlertController() {
    let alertController = UIAlertController(title: "Add a Comment", message: "This app is anonymous. Have at it", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.placeholder = "Your witty comment here"
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let commentAction = UIAlertAction(title: "Comment", style: .default) { (_) in
      guard let commentText = alertController.textFields?.first?.text,
        !commentText.isEmpty,
        let post = self.post else { return }
      PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
      })
      self.tableView.reloadData()
    }
    alertController.addAction(cancelAction)
    alertController.addAction(commentAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - Actions
  @IBAction func commentButtonTapped(_ sender: Any) {
    presentCommentAlertController()
  }
  
  @IBAction func shareButtonTapped(_ sender: Any) {
    guard let comment = post?.caption else { return }
    let shareSheet = UIActivityViewController(activityItems: [comment], applicationActivities: nil)
    present(shareSheet, animated: true, completion: nil)
  }
  
  @IBAction func followButtonTapped(_ sender: Any) {
  }
}

// MARK: - UITableViewDataSource
extension PostDetailTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return post?.comments.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
    let comment = post?.comments[indexPath.row]
    cell.textLabel?.text = comment?.text
    cell.detailTextLabel?.text = comment?.timestamp.stringWith(dateStyle: .medium, timeStyle: .short)
    return cell
  }
}

extension UIViewController {
    
}

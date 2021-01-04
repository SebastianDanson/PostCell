//
//  postCell.swift
//  CourseLnk
//
//  Created by Student on 2020-09-27.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

private let imageReuseIdentifier = "ImageCell"
private let fileReuseIdentifier = "FileCell"

protocol PostCellDelegate: class {
    func scrollToReply(withId id: String)
    func toggleClip(gestureRecognizer: UITapGestureRecognizer)
}

class PostCell: UICollectionViewCell {
    
    //MARK: - Properties
    var chatController: ChatController?
    var clippedPostsController: ClippedPostsViewController?

  
    var post: Post? {
        didSet {
            configure()}
    }
    
    var imageCollectionViewLeftAnchor: NSLayoutConstraint!
    var imageCollectionViewRightAnchor: NSLayoutConstraint!
    var imageCollectionViewWidthAnchor: NSLayoutConstraint!
    var imageCollectionViewBottomAnchor: NSLayoutConstraint!
    var imageCollectionViewBottomPaddingAnchor: NSLayoutConstraint!
    
    var oneImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var twoImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var threeImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var fourImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var fiveAndSixImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var sevenToNineImageCollectionViewHeightAnchor: NSLayoutConstraint!
    var zeroImageCollectionViewHeightAnchor: NSLayoutConstraint!
    
    var fileTableViewLeftAnchor: NSLayoutConstraint!
    var fileTableViewRightAnchor: NSLayoutConstraint!
    var fileTableViewBottomAnchor: NSLayoutConstraint!
    var fileTableViewBottomPaddingAnchor: NSLayoutConstraint!
    var fileTableViewTopAnchor: NSLayoutConstraint!
    var fileTableViewUsernameTopAnchor: NSLayoutConstraint!
    var fileTableViewReplyTopAnchor: NSLayoutConstraint!
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleWidthAnchor: NSLayoutConstraint!
    var bubbleEmptyTopAnchor: NSLayoutConstraint!
    var bubbleTopAnchor: NSLayoutConstraint!
    var bubbleBottomAnchor: NSLayoutConstraint!
    var bubbleBottomPaddingAnchor: NSLayoutConstraint!
    var bubbleCenterXAnchor: NSLayoutConstraint!
    
    var profileImageBottomAnchor: NSLayoutConstraint!
    var profileImageBottomPaddingAnchor: NSLayoutConstraint!
    
    var repliedViewLeftAnchor: NSLayoutConstraint!
    var repliedViewRightAnchor: NSLayoutConstraint!
    
    var tagStackViewLeftAnchor: NSLayoutConstraint!
    var tagStackViewRightAnchor: NSLayoutConstraint!
    
    var fileNameLeftAnchor: NSLayoutConstraint!
    var fileNameRightAnchor: NSLayoutConstraint!
    var fileNameSmallHeightAnchor: NSLayoutConstraint!
    var fileNameZeroHeightAnchor: NSLayoutConstraint!
    
    var textViewTopWithPaddingAnchor: NSLayoutConstraint!
    var textViewBottomWithPaddingAnchor: NSLayoutConstraint!
    
    var textViewTopAnchor: NSLayoutConstraint!
    var textViewBottomAnchor: NSLayoutConstraint!
    var textViewCenterXAnchor: NSLayoutConstraint!
    
    var previewViewTextLeftAnchor: NSLayoutConstraint!
    var previewViewFileLeftAnchor: NSLayoutConstraint!
    var previewViewImageLeftAnchor: NSLayoutConstraint!
    
    var previewViewRightAnchor: NSLayoutConstraint!
    var previewViewTextRightAnchor: NSLayoutConstraint!
    var previewViewFileRightAnchor: NSLayoutConstraint!
    var previewViewImageRightAnchor: NSLayoutConstraint!
    
    var previewViewFileTopAnchor: NSLayoutConstraint!
    var previewViewImageTopAnchor: NSLayoutConstraint!
    var previewViewTextTopAnchor: NSLayoutConstraint!
    
    var previewViewBottomAnchor: NSLayoutConstraint!
    var previewViewBottomPaddingAnchor: NSLayoutConstraint!
    
    var clipViewTextRightAnchor: NSLayoutConstraint!
    var clipViewFileRightAnchor: NSLayoutConstraint!
    var clipViewImageRightAnchor: NSLayoutConstraint!
    
    var clipViewTextLeftAnchor: NSLayoutConstraint!
    var clipViewFileLeftAnchor: NSLayoutConstraint!
    var clipViewImageLeftAnchor: NSLayoutConstraint!
    
    var clipViewZeroHeightAnchor: NSLayoutConstraint!
    var clipViewHeightAnchor: NSLayoutConstraint!
    
    var clipImageViewZeroHeightAnchor: NSLayoutConstraint!
    var clipImageViewHeightAnchor: NSLayoutConstraint!

    
    let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let fileTableView = DynamicTableView()
    private var fileCount = 0
    private var files = [(src: String, name: String)]()
    private var wasSentByYou = false
    
    private lazy var tagStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.layer.cornerRadius = 12
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private let tagView: UIView = {
        let view = UIView()
        view.setHeight(height: 32)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .mainGreen
        return view
    }()
    
    
    private lazy var noteImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "noteFilterWhite"))
        //iv.isHidden = true
        iv.tintColor = .black
        iv.setDimensions(height: 16, width: 16)
        return iv
    }()
    
    private lazy var assignmentImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "assignmentFilterWhite"))
        //iv.isHidden = true
        iv.tintColor = .white
        iv.setDimensions(height: 16, width: 16)
        return iv
    }()
    
    private lazy var questionImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "questionFilterWhite"))
        //iv.isHidden = true
        iv.tintColor = .white
        iv.setDimensions(height: 16, width: 16)
        return iv
    }()
    
    private lazy var examImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "examFilterWhite"))
        //iv.isHidden = true
        iv.tintColor = .white
        iv.setDimensions(height: 16, width: 16)
        return iv
    }()


    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lighterGray
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    
    private let clipView: UIView = {
        let view = UIView()
        view.backgroundColor = .lighterGray
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let clipImageView: UIImageView = {
        let iv = UIImageView()
        iv.setWidth(width: 18)
        iv.tintColor = .mainGreen
        iv.image = UIImage(systemName: "paperclip")
        return iv
    }()
    
    private var numClipsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .mainGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var numClips = 0
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .none
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    private let fileName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    
    lazy var bubbleContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var repliedView: RepliedView = {
        let view = RepliedView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var previewView = UIView()
    weak var delegate: PostCellDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageReuseIdentifier)
        
        addSubview(repliedView)
        repliedView.anchor(top: topAnchor, paddingTop: 4)
        
        addSubview(previewView)
        previewView.addSubview(collectionView)
        previewView.addSubview(profileImageView)
        previewView.addSubview(bubbleContainer)
        previewView.addSubview(fileTableView)
        previewView.addSubview(clipView)
        
        bubbleContainer.addSubview(textView)

        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: bubbleContainer.leftAnchor, paddingLeft: 10)
        
        previewView.backgroundColor = .none
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewViewFileTopAnchor = previewView.topAnchor.constraint(equalTo: fileTableView.topAnchor, constant: 4)
        previewViewImageTopAnchor = previewView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        previewViewTextTopAnchor = previewView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor)
    
        previewViewBottomAnchor = previewView.bottomAnchor.constraint(equalTo: bottomAnchor)
        previewViewBottomPaddingAnchor = previewView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        
        previewViewTextLeftAnchor = previewView.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor)
        previewViewFileLeftAnchor = previewView.leftAnchor.constraint(equalTo: fileTableView.leftAnchor)
        previewViewImageLeftAnchor = previewView.leftAnchor.constraint(equalTo: collectionView.leftAnchor)
        
        previewViewRightAnchor = previewView.rightAnchor.constraint(equalTo: bubbleContainer.rightAnchor)
        previewViewTextRightAnchor = previewView.rightAnchor.constraint(equalTo: bubbleContainer.rightAnchor)
        previewViewFileRightAnchor = previewView.rightAnchor.constraint(equalTo: fileTableView.rightAnchor)
        previewViewImageRightAnchor = previewView.rightAnchor.constraint(equalTo: collectionView.rightAnchor)
        
        previewView.layer.cornerRadius = 18
        
        fileTableView.register(FileCell.self, forCellReuseIdentifier: fileReuseIdentifier)
        fileTableView.delegate = self
        fileTableView.dataSource = self
        
        fileTableView.separatorStyle = .none
        fileTableView.backgroundColor = .none
        fileTableView.estimatedRowHeight = 44
        
        fileTableView.translatesAutoresizingMaskIntoConstraints = false
        fileTableView.maxHeight = 1000
        fileTableViewReplyTopAnchor = fileTableView.topAnchor.constraint(equalTo: repliedView.bottomAnchor, constant: -20)
        fileTableViewUsernameTopAnchor = fileTableView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: -2)
        fileTableViewTopAnchor = fileTableView.topAnchor.constraint(equalTo: topAnchor)
        profileImageView.anchor(left: leftAnchor,
                                paddingLeft: 8)
        profileImageBottomAnchor = profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        profileImageBottomPaddingAnchor = profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        
        profileImageView.setDimensions(height: 26, width: 26)
        profileImageView.layer.cornerRadius = 26/2
        
        bubbleBottomAnchor = bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        bubbleBottomPaddingAnchor = bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        bubbleCenterXAnchor = bubbleContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        
        bubbleTopAnchor = bubbleContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 3)
        bubbleEmptyTopAnchor = bubbleContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        
        bubbleWidthAnchor = bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.75)
        bubbleWidthAnchor.isActive = true
        bubbleContainer.translatesAutoresizingMaskIntoConstraints = false
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        
        repliedView.translatesAutoresizingMaskIntoConstraints = false
        repliedViewLeftAnchor = repliedView.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor)
        repliedViewRightAnchor = repliedView.rightAnchor.constraint(equalTo: bubbleContainer.rightAnchor)
        imageCollectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        imageCollectionViewBottomPaddingAnchor = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        imageCollectionViewWidthAnchor = collectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.65)
        imageCollectionViewLeftAnchor = collectionView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        imageCollectionViewRightAnchor = collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        imageCollectionViewWidthAnchor.isActive = true
        
        fileTableViewLeftAnchor = fileTableView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        fileTableViewRightAnchor = fileTableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        fileTableViewBottomAnchor = fileTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        fileTableViewBottomPaddingAnchor = fileTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        
        
        zeroImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 0)
        oneImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2.5)
        twoImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/7)
        threeImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/9)
        fourImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3.5)
        fiveAndSixImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4.5)
        sevenToNineImageCollectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3)
  
        
        collectionView.anchor(top: fileTableView.bottomAnchor)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.anchor(left: bubbleContainer.leftAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingLeft: 8, paddingRight: 8)
        textViewTopAnchor = textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor)
        textViewBottomAnchor = textView.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor)
        textViewTopWithPaddingAnchor = textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 2)
        textViewBottomWithPaddingAnchor = textView.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: 2)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        
        collectionView.layer.cornerRadius = 18
        
        clipView.anchor(bottom: bottomAnchor)
        
        clipViewTextLeftAnchor = clipView.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor)
        clipViewFileLeftAnchor = clipView.leftAnchor.constraint(equalTo: fileTableView.leftAnchor)
        clipViewImageLeftAnchor = clipView.leftAnchor.constraint(equalTo: collectionView.leftAnchor)
        
        clipViewTextRightAnchor = clipView.rightAnchor.constraint(equalTo: bubbleContainer.rightAnchor)
        clipViewFileRightAnchor = clipView.rightAnchor.constraint(equalTo: fileTableView.rightAnchor)
        clipViewImageRightAnchor = clipView.rightAnchor.constraint(equalTo: collectionView.rightAnchor)
        
        clipViewHeightAnchor = clipView.heightAnchor.constraint(equalToConstant: 22)
        clipViewZeroHeightAnchor = clipView.heightAnchor.constraint(equalToConstant: 0)
        
        clipImageViewHeightAnchor = clipImageView.heightAnchor.constraint(equalToConstant: 18)
        clipImageViewZeroHeightAnchor = clipImageView.heightAnchor.constraint(equalToConstant: 0)
        clipImageViewZeroHeightAnchor.isActive = true
        clipViewZeroHeightAnchor.isActive = true
        
        clipView.addSubview(clipImageView)
        clipView.addSubview(numClipsLabel)
        
        clipImageView.centerY(inView: clipView)
        clipImageView.anchor(left: numClipsLabel.rightAnchor, right: clipView.rightAnchor, paddingRight: 5)
        
        numClipsLabel.centerY(inView: clipView, leftAnchor: clipView.leftAnchor, paddingLeft: 5)
        clipView.isHidden = true
        
        addSubview(tagView)
        tagView.addSubview(tagStackView)
        tagView.anchor(left: tagStackView.leftAnchor, bottom: previewView.topAnchor, right: tagStackView.rightAnchor, paddingLeft: -8, paddingBottom: -14, paddingRight: -8)
        tagStackView.centerY(inView: tagView)
        
        tagStackViewLeftAnchor = tagView.leftAnchor.constraint(equalTo: previewView.rightAnchor, constant: -12)
        tagStackViewRightAnchor = tagView.rightAnchor.constraint(equalTo: previewView.leftAnchor, constant: 12)

        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleClip))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers
    
    func configureConsecutivePostsFromSameUser() {
        guard let post = post else {return}
        let viewModel = PostViewModel(post: post)
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        if viewModel.shouldHideProfileImage {
            profileImageView.isHidden = true
            return
        }

        if post.isFirstPostInARowFromUser && post.isLastPostInARowFromUser {
            profileImageView.isHidden = false
            usernameLabel.isHidden = false
        } else if post.isFirstPostInARowFromUser && !post.isLastPostInARowFromUser {
            profileImageView.isHidden = true
            usernameLabel.isHidden = false
        } else if !post.isFirstPostInARowFromUser && !post.isLastPostInARowFromUser {
            profileImageView.isHidden = true
            usernameLabel.text = ""
        } else {
            profileImageView.isHidden = false
            usernameLabel.text = ""
        }
        
    }
    
    func setTagView() {
        guard let post = post else {return}
        
        assignmentImageView.removeFromSuperview()
        questionImageView.removeFromSuperview()
        examImageView.removeFromSuperview()
        noteImageView.removeFromSuperview()
        
        if post.assignmentsTag {
            tagStackView.addArrangedSubview(assignmentImageView)
            tagView.isHidden = false
        }
        
        if post.questionsTag {
            tagStackView.addArrangedSubview(questionImageView)
            tagView.isHidden = false
        }
        
        if post.examsTag {
            tagStackView.addArrangedSubview(examImageView)
            tagView.isHidden = false
        }
        
        if post.notesTag {
            tagStackView.addArrangedSubview(noteImageView)
            tagView.isHidden = false
        }
        
    }
    
    func configure() {
        guard let post = post else {return}
        
        let viewModel = PostViewModel(post: post)
        fileCount = post.files.count
        files = [(src: String, name: String)]()
        
        for file in post.files {
            if let src = file["src"] as? String{
                if !(src.contains(".png")) {
                    files.append((src: src, name: file["name"] as? String ?? ""))
                }
            }
        }
        
        wasSentByYou = viewModel.rightAnchorActive
        tagView.isHidden = true
        setTagView()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.fileTableView.reloadData()

        
        fileTableViewTopAnchor.isActive = false
        fileTableViewReplyTopAnchor.isActive = false
        fileTableViewUsernameTopAnchor.isActive = false
        

        if let firstname = post.username.components(separatedBy: " ").first {
            usernameLabel.text = firstname
        }
        
        if post.isReply  {
            usernameLabel.text = ""
            let data = ["content":post.replyContent,
                        "files":post.replyFiles,
                        "username": post.username,
                        "replyUsername": post.replyUsername,
                        "id": post.parentId,
            ] as [String: Any]
            repliedView.post = Post(dictionary: data, isFromCurrentUser: post.isFromCurrentUser)
            repliedView.isHidden = false
            usernameLabel.isHidden = true
            fileTableViewReplyTopAnchor.isActive = true
        } else {
            repliedView.isHidden = true
            if wasSentByYou {
                fileTableViewTopAnchor.isActive = true
                usernameLabel.isHidden = true
            } else {
                fileTableViewUsernameTopAnchor.isActive = true
                usernameLabel.isHidden = false
            }
        }
        
        configureConsecutivePostsFromSameUser()

        zeroImageCollectionViewHeightAnchor.isActive = false
        oneImageCollectionViewHeightAnchor.isActive = false
        twoImageCollectionViewHeightAnchor.isActive = false
        threeImageCollectionViewHeightAnchor.isActive = false
        fourImageCollectionViewHeightAnchor.isActive = false
        fiveAndSixImageCollectionViewHeightAnchor.isActive = false
        sevenToNineImageCollectionViewHeightAnchor.isActive = false
        
        switch fileCount - files.count {
        case 1:
            oneImageCollectionViewHeightAnchor.isActive = true
        case 2:
            twoImageCollectionViewHeightAnchor.isActive = true
        case 3:
            threeImageCollectionViewHeightAnchor.isActive = true
        case 4:
            fourImageCollectionViewHeightAnchor.isActive = true
        case 5...6:
            fiveAndSixImageCollectionViewHeightAnchor.isActive = true
        case 7...9:
            sevenToNineImageCollectionViewHeightAnchor.isActive = true
        default:
            zeroImageCollectionViewHeightAnchor.isActive = true
        }
        
        imageCollectionViewLeftAnchor.isActive = false
        imageCollectionViewRightAnchor.isActive = false
        repliedViewLeftAnchor.isActive = false
        repliedViewRightAnchor.isActive = false
        fileTableViewLeftAnchor.isActive = false
        fileTableViewRightAnchor.isActive = false
        tagStackViewLeftAnchor.isActive = false
        tagStackViewRightAnchor.isActive = false
        
        bubbleContainer.backgroundColor = viewModel.postBackgroundColor
        textView.textColor = viewModel.postTextColor
        textView.text = post.content
        
        imageCollectionViewLeftAnchor.isActive = viewModel.leftAnchorActive
        imageCollectionViewRightAnchor.isActive = viewModel.rightAnchorActive
        
        fileTableViewLeftAnchor.isActive = viewModel.leftAnchorActive
        fileTableViewRightAnchor.isActive = viewModel.rightAnchorActive
        
        repliedViewLeftAnchor.isActive = viewModel.leftAnchorActive
        repliedViewRightAnchor.isActive = viewModel.rightAnchorActive
        
        tagStackViewLeftAnchor.isActive = viewModel.leftAnchorActive
        tagStackViewRightAnchor.isActive = viewModel.rightAnchorActive
        
        previewViewTextLeftAnchor.isActive = false
        previewViewFileLeftAnchor.isActive = false
        previewViewImageLeftAnchor.isActive = false
        
        previewViewRightAnchor.isActive = false
        previewViewTextRightAnchor.isActive = false
        previewViewFileRightAnchor.isActive = false
        previewViewImageRightAnchor.isActive = false
        
        previewViewFileTopAnchor.isActive = false
        previewViewTextTopAnchor.isActive = false
        previewViewImageTopAnchor.isActive = false
        
        
        //Setting previewView top anchor based on post content
        if files.count > 0 {
            previewViewFileTopAnchor.isActive = true
        } else if fileCount - files.count > 0 {
            previewViewImageTopAnchor.isActive = true
        } else {
            previewViewTextTopAnchor.isActive = true
        }
        
        //If post is from another user
        if viewModel.leftAnchorActive {
            previewViewTextLeftAnchor.isActive = true
            //Setting right anchor based on post content
            if fileCount - files.count > 0 {
                previewViewImageRightAnchor.isActive = true
            } else if fileCount == 0 {
                previewViewTextRightAnchor.isActive = true
            } else if bubbleContainer.frame.width < fileTableView.frame.width {
                previewViewFileRightAnchor.isActive = true
            } else {
                previewViewTextRightAnchor.isActive = true
            }
            
        } else {
            //The current user sent the post
            previewViewRightAnchor.isActive = true
            
            //Setting left anchor based on post content
            if fileCount - files.count > 0 {
                previewViewImageLeftAnchor.isActive = true
            } else if fileCount == 0 {
                previewViewTextLeftAnchor.isActive = true
            } else if bubbleContainer.frame.width < fileTableView.frame.width {
                previewViewFileLeftAnchor.isActive = true
            } else {
                previewViewTextLeftAnchor.isActive = true
            }
        }
        
        textViewTopAnchor.isActive = false
        textViewBottomAnchor.isActive = false
        textViewTopWithPaddingAnchor.isActive = false
        textViewBottomWithPaddingAnchor.isActive = false
        imageCollectionViewBottomAnchor.isActive = false
        bubbleTopAnchor.isActive = false
        bubbleEmptyTopAnchor.isActive = false
        fileTableViewBottomAnchor.isActive = false
        fileTableViewBottomPaddingAnchor.isActive = false
        imageCollectionViewBottomAnchor.isActive = false
        imageCollectionViewBottomPaddingAnchor.isActive = false

        if post.content == "" {
            textViewTopAnchor.isActive = true
            textViewBottomAnchor.isActive = true
            bubbleEmptyTopAnchor.isActive = true
            
            if post.clips > 0 {
                imageCollectionViewBottomPaddingAnchor.isActive = true
            } else{
                imageCollectionViewBottomAnchor.isActive = true
            }
            
        } else {
            bubbleTopAnchor.isActive = true
            textViewTopAnchor.isActive = true
            textViewBottomAnchor.isActive = true
        }
        
        clipViewTextLeftAnchor.isActive = false
        clipViewFileLeftAnchor.isActive = false
        clipViewImageLeftAnchor.isActive = false
        
        clipViewTextRightAnchor.isActive = false
        clipViewFileRightAnchor.isActive = false
        clipViewImageRightAnchor.isActive = false
        
        //If post is from current user
        if viewModel.rightAnchorActive {
            if post.content != "" {
                clipViewTextLeftAnchor.isActive = true
            } else if fileCount - files.count > 0 {
                clipViewImageLeftAnchor.isActive = true
            } else {
                clipViewFileLeftAnchor.isActive = true
            }
        } else {
            if post.content != "" {
                clipViewTextRightAnchor.isActive = true
            } else if fileCount - files.count > 0 {
                clipViewImageRightAnchor.isActive = true
            } else {
                clipViewFileRightAnchor.isActive = true
            }
        }
        
        clipViewZeroHeightAnchor.isActive = false
        clipImageViewZeroHeightAnchor.isActive = false
        clipViewHeightAnchor.isActive = false
        clipImageViewHeightAnchor.isActive = false
        bubbleBottomAnchor.isActive = false
        bubbleBottomPaddingAnchor.isActive = false
        profileImageBottomAnchor.isActive = false
        profileImageBottomPaddingAnchor.isActive = false
        previewViewBottomAnchor.isActive = false
        previewViewBottomPaddingAnchor.isActive = false
        
        if post.clips > 0 {
            clipView.isHidden = false
            numClips = post.clips
            numClipsLabel.text = "\(numClips)"
            clipViewHeightAnchor.isActive = true
            clipImageViewHeightAnchor.isActive = true
            profileImageBottomPaddingAnchor.isActive = true
            bubbleBottomPaddingAnchor.isActive = true
            previewViewBottomPaddingAnchor.isActive = true
            
        } else {
            clipViewZeroHeightAnchor.isActive = true
            clipImageViewZeroHeightAnchor.isActive = true
            bubbleBottomAnchor.isActive = true
            clipView.isHidden = true
            profileImageBottomAnchor.isActive = true
            previewViewBottomAnchor.isActive = true
        }
        
        bubbleCenterXAnchor.isActive = false
        bubbleLeftAnchor.isActive = false
        bubbleRightAnchor.isActive = false
        
        if post.username == "" {
            bubbleCenterXAnchor.isActive = true
            
            bubbleContainer.backgroundColor = .lighterGray
            profileImageView.isHidden = true
            textView.textColor = .mainGray
            isUserInteractionEnabled = false
        } else {
            isUserInteractionEnabled = true
            bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
            bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        }
        
    }
    
    @objc func toggleClip(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleClip(gestureRecognizer: gestureRecognizer)
    }
    
}

extension PostCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileCount - files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageReuseIdentifier, for: indexPath) as! ImageCell
        if !(indexPath.row < fileCount) {return cell}
        let src = post?.files[indexPath.row]["src"] as? String ?? ""
        cell.chatController = self.chatController
        cell.clippedPostsController = self.clippedPostsController
        let url = URL(string: src)
        cell.setImage(withUrl: url)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch fileCount - files.count {
        case 1:
            width = collectionView.bounds.width
            height = collectionView.bounds.height
        case 2:
            width = collectionView.bounds.width/2
            height = collectionView.bounds.height
        case 3:
            width = collectionView.bounds.width/3
            height = collectionView.bounds.height
        case 4:
            width = collectionView.bounds.width/2
            height = collectionView.bounds.height/2
        case 5...6:
            width = collectionView.bounds.width/3
            height = collectionView.bounds.height/2
        case 7...9:
            width = collectionView.bounds.width/3
            height = collectionView.bounds.height/3
        default:
            width = 0
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
}


extension PostCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fileReuseIdentifier) as! FileCell
        let name = files[indexPath.row].name
        let src = files[indexPath.row].src
        cell.chatController = self.chatController
        cell.setFile(name: name, src: src, wasSentByYou: wasSentByYou, isReply: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension PostCell: RepliedViewDelegate {
    func scrollToReply(withId id: String) {
        delegate?.scrollToReply(withId: id)
    }
}

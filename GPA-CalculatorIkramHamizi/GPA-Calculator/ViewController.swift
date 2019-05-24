//
//  ViewController.swift
//  GPA-Calculator
//
//  Created by cstech on 2/10/18.
//  Copyright © 2018 cstech. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate{
    
    //1. OUTLETS and VARS s
    //App Title: ImageView
    @IBOutlet weak var TitleGPA: UIImageView!
    
    //Grey Container: View
    @IBOutlet weak var GreyView: UIView!
    
    //Buttons
    @IBOutlet weak var AddCourseB: UIButton!
    @IBOutlet weak var DeleteCourseB: UIButton!
    
    //Labels
    @IBOutlet weak var TitleCourseL: UILabel!
    @IBOutlet weak var AssTypeL: UILabel!
    @IBOutlet weak var AssL: UILabel!
    @IBOutlet weak var Midterm: UILabel!
    @IBOutlet weak var FinalL: UILabel!
    @IBOutlet weak var CreditL: UILabel!
    @IBOutlet weak var GPAL: UILabel!
    @IBOutlet weak var CurrentListTitleL: UILabel!
    
    var ArrNumberLabelsGroup = [UILabel]()
    @IBOutlet weak var n1L: UILabel!
    @IBOutlet weak var n2L: UILabel!
    @IBOutlet weak var n3L: UILabel!
    @IBOutlet weak var n4L: UILabel!
    
    var ArrCourseLabelsGroup = [UILabel]()
    @IBOutlet weak var Course1L: UILabel!
    @IBOutlet weak var Course2L: UILabel!
    @IBOutlet weak var Course3L: UILabel!
    @IBOutlet weak var Course4L: UILabel!
    
    //Text Fileds
    @IBOutlet weak var TitleCourseTF: UITextField!
    @IBOutlet weak var C11: UITextField!
    @IBOutlet weak var C12: UITextField!
    @IBOutlet weak var C13: UITextField!
    @IBOutlet weak var C21: UITextField!
    @IBOutlet weak var C22: UITextField!
    @IBOutlet weak var C23: UITextField!
    @IBOutlet weak var C31: UITextField!
    @IBOutlet weak var C32: UITextField!
    @IBOutlet weak var C33: UITextField!
    @IBOutlet weak var CreditTF: UITextField!
    @IBOutlet weak var DeleteCourseTF: UITextField!
    var ArrAllTF = [UITextField]() //TF = Text Field
    
    //ChalkBoard: ImageView
    @IBOutlet weak var ChackBoardImg: UIImageView!
    @IBOutlet weak var grade1Img: UIImageView!
    @IBOutlet weak var grade2Img: UIImageView!
    @IBOutlet weak var grade3Img: UIImageView!
    @IBOutlet weak var grade4Img: UIImageView!
    
    //Variables
    var ArrTitle_course = [String]()
    var count: Int = 0
    var total_credits: Int = 0
    var letterGrade: String = "j"
    var grade: Double = 0.00
    var GPA: Double = 0.00
    var gradeGPA: Double = 0.00
    var ArrCourses = [Course]()
    var ArrGradeIMAGE = [UIImageView!]()
    var gradeIMAGE: UIImageView!
    
    //2. ACTIONS
    //1-Saving title of course from text field
    @IBAction func addNewCourse(_ sender: UIButton) -> Void {
        let courseTitle: String = TitleCourseTF.text!
        
        if(count == 4)
        {
            createAlert("Error", "You cannot add more than 4 course")
        }
        else if (courseTitle == "")
        {
            createAlert("Error", "Please enter a course name.")
        }
        else if (ArrTitle_course.contains(courseTitle))
        {
            createAlert("Error", "You already have this class in your list")
        }
        //1~Check if input is correct
        else if let P11 = Double(C11.text!), let P21 = Double(C21.text!), let P31 = Double(C31.text!), let M12 = Double(C12.text!), let M22 = Double(C22.text!), let M32 = Double(C32.text!), let Per13 = Double(C13.text!), let Per23 = Double(C23.text!), let Per33 = Double(C33.text!), let course_credit = Int(CreditTF.text!)
        {
            if(P11>M12 || P21>M22 || P31>M32 || (Per13+Per23+Per33 != 100) || P11<0 || P21<0 || P31<0 || course_credit<0)
            {
                createAlert("Error", "You did not enter your fields accurately, please re-enter your grades")
            }
            else
            {
                grade = P11/M12*Per13 + P21/M22*Per23 + P31/M32*Per33
                print ("\(courseTitle): \(grade)")

                letterGrade = "N"
                total_credits += course_credit
                
                //2~ Calculate Course Grade and LetterGrade
                switch(count+1)
                {
                case 1:
                    gradeIMAGE = grade1Img
                case 2:
                    gradeIMAGE = grade2Img
                case 3:
                    gradeIMAGE = grade3Img
                case 4:
                    gradeIMAGE = grade4Img
                default:
                    gradeIMAGE = grade1Img
                }
                
                switch(grade){
                case 90...100:
                    letterGrade = "A"
                    gradeIMAGE.image = UIImage(named: "grade_a")
                    gradeIMAGE.isHidden = false
                    gradeGPA = 4.00
                case 80...89.9:
                    letterGrade = "B"
                    gradeIMAGE.image = UIImage(named: "grade_b")
                    gradeIMAGE.isHidden = false
                    gradeGPA = 3.00
                case 70...79.9:
                    letterGrade = "C"
                    gradeIMAGE.image = UIImage(named: "grade_c")
                    gradeIMAGE.isHidden = false
                    gradeGPA = 2.00
                case 60...69.9:
                    letterGrade = "D"
                    gradeIMAGE.image = UIImage(named: "grade_d")
                    gradeIMAGE.isHidden = false
                    gradeGPA = 1.00
                case 0...59.9:
                    gradeIMAGE.image = UIImage(named: "grade_f")
                    gradeIMAGE.isHidden = false
                    letterGrade = "F"
                    gradeGPA = 0.00
                default:
                    gradeIMAGE.isHidden = true
                    createAlert("Error", "Pease re-enter your grades correctly")
                }
                
                //3~Append Course to our arrays
                ArrTitle_course.append(courseTitle)
                ArrCourses.append(Course.init(letterGrade, courseTitle, course_credit, gradeGPA))
                count+=1;

                displayOnChalkBoard(ArrCourses[count-1], GPA)
                DeleteCourseB.isHidden = false
                DeleteCourseTF.isHidden = false
            }
        }
        else{
            createAlert("Wrong Input", "Please enter a number")
        }
    }
    
    //2- Delete course + adjust gpa
    @IBAction func DeleteCourseA(_ sender: UIButton) {
        
        //Shift courses
        if let course = Int(DeleteCourseTF.text!) {
            if(course<=count && course>0) {
                let index = course-1
                
                total_credits -= ArrCourses[index].course_credit
                print ("DELETED: \(ArrCourses[index])")
                ArrCourseLabelsGroup[index].text? = ""

                ArrCourses.remove(at: index)
                ArrTitle_course.remove(at: index)
                
                for i in stride (from: index, to: count-1, by: 1) {
                    ArrCourseLabelsGroup[i].text? = (" \(ArrCourseLabelsGroup[i+1].text!)")
                    ArrGradeIMAGE[i].image = ArrGradeIMAGE[i+1].image!
                }
                
                ArrNumberLabelsGroup[count-1].isHidden = true
                ArrGradeIMAGE[count-1].isHidden = true
                ArrCourseLabelsGroup[count-1].text? = ""

                count-=1;
                
                //Calculate + Switch gpa color
                CalculateGpaAndColor()
            }
            else
            {
                createAlert("Error", "There is no course with this index in your list.")
            }
        }
        
        //Hide DeleteCourseB when there are no courses
        if(count==0)
        {
            DeleteCourseB.isHidden = true
            DeleteCourseTF.isHidden = true
            GPAL.textColor = UIColor.white
        }
    }
    
    //3. FUNCTIONS
    //1- FUNC VIEWDIDLOAD ***
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArrGradeIMAGE = [grade1Img, grade2Img, grade3Img, grade4Img]
        ArrNumberLabelsGroup = [n1L, n2L, n3L, n4L]
        
        //Hide DeleteCourseB when there are no courses
        DeleteCourseB.isHidden = true
        DeleteCourseTF.isHidden = true
        
        var ArrShadow = [UIView]()
        ArrShadow = [ChackBoardImg, AddCourseB, DeleteCourseB]
        
        for each in ArrShadow {
            each.layer.shadowColor = UIColor (displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            each.layer.shadowOffset = CGSize(width: 0, height: 1.75)
            each.layer.shadowRadius = 1.7
            each.layer.shadowOpacity = 0.45
        }
        
        Course1L.text = ""
        Course2L.text = ""
        Course3L.text = ""
        Course4L.text = ""
        
        GPAL.text = "GPA: "
        ArrCourseLabelsGroup = [Course1L, Course2L, Course3L, Course4L]
        ArrAllTF = [TitleCourseTF, C11, C12, C13, C21, C22, C23, C31, C32, C33, CreditTF, DeleteCourseTF]
        
        for each in ArrNumberLabelsGroup {
            each.isHidden = true
        }
        
        for each in ArrAllTF {
            each.delegate = self
        }
    }
    
    //2- Display Courses on Chalkboard
    func displayOnChalkBoard(_ course: Course, _ gpa: Double){
        
        ArrNumberLabelsGroup[count-1].isHidden = false
        
        ArrCourseLabelsGroup[count-1].text? = " \(course.course_title) (\(course.course_credit)): \(course.course_gradeLetter)"
        
        CalculateGpaAndColor() //will also display GPA on chalkboard
    }
    
    //3- Calculate GPA: sigma[(gradeGPA*course_credit)]/total_credits + Display GPA on chalboard
    func CalculateGpaAndColor()
    {
        GPA = 0.00
        var sum: Double = 0.00
        
        for each in ArrCourses {
            sum += Double(each.course_gradeGPA) * Double(each.course_credit)
        }
        
        GPA = Double(sum)/Double(total_credits)
        if(GPA.isNaN) {
            GPAL.text = "GPA: 0.0"
        }
        else {
            let a = String(format: "%.2f", GPA)
            GPAL.text = "GPA: \(a)"
            print ("GPA: \(a)")
        }
        
        switch(GPA)
        {
        case 3.0...4.0:
            GPAL.textColor = UIColor.green
        case 2.0...2.99:
            GPAL.textColor = UIColor.orange
        default:
            GPAL.textColor = UIColor.red
        }
    }
    
    //4- Hide keyboard when Screen touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //5- ALERT Function
    func createAlert(_ title: String, _ message: String)
    {
        //Create Alert Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //Create Action for Alert (OK button)
        let okAlert = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        //Add action to alert
        alert.addAction(okAlert)
        
        //Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //6- Hide keyboard when return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Course {
    var course_credit : Int
    var course_title : String
    var course_gradeGPA : Double
    var course_gradeLetter : String
    
    init(_ course_gradeLetter : String, _ course_title: String, _ course_credit: Int, _ course_gradeGPA: Double) {
        self.course_credit = course_credit
        self.course_title = course_title
        self.course_gradeGPA = course_gradeGPA
        self.course_gradeLetter = course_gradeLetter
    }
}





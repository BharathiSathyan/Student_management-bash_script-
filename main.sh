#!/bin/bash

function create_user() {
    echo "Enter $1 id:"
    read user_id
        if grep "$user_id" "$1.csv"; then
                echo "Already exist."
                return
        fi
        echo "Enter $1 name:"
        read user_name
        echo "$user_id,$user_name" >> "$1.csv"
        cat "$1.csv"    #remove
        echo "Successfully created!"
}

function create_sem() {
        view_sem
        echo "Enter New Semester to add : "
        read sem
        if grep "$sem" "semester.csv"; then
                echo "Already exist."
                return
        fi

        echo "$sem" >> "semester.csv"
        view_sem
        echo "Successfully created!"
}

function create_course() {
        view_course
        echo "Enter Course code : "
        read c_code
        echo "Enter Course Name : "
        read c_name
        echo "Enter Semester : "
        read c_sem
        echo "Enter faculty ID : "
        read c_fid
        if grep -i "$c_code" "course.csv"; then
                echo "Already exist."
                return
        fi
                if grep -i "$c_sem" "semester.csv"; then
                        if grep "$c_fid" "faculty.csv"; then
                                echo "$c_code,$c_name,$c_sem,$c_fid" >> "course.csv"
                                echo "successfully created!!"
                        else
                                echo "faculty ID Doesnot exist!"
                                return
                        fi
                else
                        echo "Semester doesnot exist!"
                        return
                fi
}

function enroll_course(){
        cat course_enroll.csv

        echo "Enter Course code : "
        read c_code
        echo "Enter Student ID : "
        read s_id
        echo "Enter Semester : "
        read sem

        if grep -i "$c_code" "course.csv"; then
                if grep -i "$sem" "semester.csv"; then
                        if grep -i "$s_id" "student.csv"; then
                                echo "$c_code,$s_id,$sem,0,0" >> "course_enroll.csv"
                                cat course_enroll.csv
                                echo "Enrolled successfully!\n"
                        else
                                echo "Student doesnot exist!"
                                return
                                return
                        fi
                else
                        echo "Semester Doesnot exist!"
                        return
                fi
        else
                echo "Course doesnot exist!"
                return
        fi
}

function view_student(){
        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2}' student.csv
}

function view_faculty(){
        echo -e "\nFACULTY_ID \t FACULTY_NAME \n"
        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2}' faculty.csv
}

function view_course(){
        echo -e "\n COURSE_CODE\tCOURSE NAME \n"
        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2}' course.csv
}

function view_sem(){
        echo -e "\n SEMESTER \n"
        awk 'BEGIN{FS=",";OFS=" \t "}{print $1}' semester.csv
}

function del_stud(){
        view_student
        echo "Enter student Roll Number to delete : "
        read s_id
        if grep -i "$s_id" "student.csv"; then
                #sed -i '/$s_id/d' student.csv
                grep -v "$s_id" student.csv > s_tmp.csv
                mv s_tmp.csv student.csv
                echo "Student removed from list!"
                view_student
        else
                echo "Student Not found!"
        fi
}

function modify_fac(){
        echo -e "\nCOURSE_CODE   FACULTY_ID \t\t COURSE NAME \n"
        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$4,$2}' course.csv
        echo "Enter Course code : "
        read c_code
        echo "Enter Old faculty ID : "
        read o_fid
        echo "Enter New Faculty ID : "
        read f_id

        if grep -i "$c_code" "course.csv"; then
                #sed -i 's/$o_fid/$f_id/g' course.csv
# Use awk to replace the value in course_enroll.csv
                awk -v old="$o_fid" -v new="$f_id" 'BEGIN{FS=OFS=","} {gsub(old, new)}1' course.csv > course_tmp.csv
# Replace the original file with the modified file
                mv course_tmp.csv course.csv
# Print the modified course_enroll.csv
                echo "Faculty Changed successfully!"
                echo -e "\n COURSE_CODE  FACULTY_ID  COURSE NAME \n"
                awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$4,$2}' course.csv
        else
                echo "Course doesnot exist!"
                return
        fi
}

function student_grade(){
        echo "Enter student roll number : "
        read roll
        echo "Enter course : "
        read course

        if grep -i "$roll" "student.csv"; then
                grep "$roll" course_enroll.csv > temp.csv
                        echo "COURSE_CODE     ROLL_NO       GRADE"
                        grep -i "$course" temp.csv >temp2.csv
                        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2,$4}' temp2.csv
        else
                echo "No courses enrolled!"
        fi
}

function check_course(){
        echo "Enter student roll number : "
        read roll

        if grep -i "$roll" "student.csv"; then
                grep "$roll" course_enroll.csv > temp.csv
                echo "COURSE_CODE     ROLL_NO"
                awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2}' temp.csv
        else
                echo "No courses Enrolled!"
        fi
}

function check_attendance(){
        echo "Enter student roll number : "
        read roll
        echo "Enter course : "
        read course

        if grep -i "$roll" "student.csv"; then
                grep "$roll" course_enroll.csv > temp.csv
                        echo "COURSE_CODE     ROLL_NO       ATTENDANCE"
                        grep -i "$course" temp.csv >temp2.csv
                        awk 'BEGIN{FS=",";OFS=" \t\t "}{print $1,$2,$5}' temp2.csv
        else
                echo "No courses enrolled!"
        fi

}

# main program
choice1="y"
while [ $choice1 == "y" ] || [ $choice1 == "Y" ]
do
    clear
                  echo "=============== WELCOME  CHOOSE A USER ==============="
                  echo -e "\t\t\t\t\t "
                  echo -e "\t\t\t\t\t "
                  echo " 1.Admin"
                  echo " 2.Student"
                  echo " 3.exit"
                  echo -e "\t"
                  echo -e "\t"
                  echo "=========================================="

                  read user_choice
case "$user_choice" in

        1)
                clear
                echo "Enter Admin password : "
                read admin_pass
                if [ "$admin_pass" = "welcome" ]; then

                #admin choice
                choice="y"
                while [ $choice == "y" ] || [ $choice == "Y" ]
                do
                    clear
                    echo "=============== Admin menu ==============="
                    echo -e "=\t\t\t\t\t ="
                    echo -e "=\t\t\t\t\t ="
                    echo -e "= 1.  Create Faculty\t\t\t ="
                    echo -e "= 2.  Create Student\t\t\t ="
                    echo -e "= 3.  Enroll students into the course\t ="
                    echo -e "= 4.  Create Semester\t\t\t ="
                    echo -e "= 5.  Create Course\t\t\t ="
                    echo -e "= 6.  Delete Student\t\t\t ="
                    echo -e "= 7.  Modify course Faculty\t\t ="

                    echo -e "= 8.  View Faculties\t\t\t ="
                    echo -e "= 9.  View Students\t\t\t ="
                    echo -e "= 10. View Semesters\t\t\t ="
                    echo -e "= 11. View Courses\t\t\t ="
                    echo -e "= 12. Exit\t\t\t\t ="
                    echo "=========================================="
                    echo "Enter your choice:"

                    read choice

                    case "$choice" in
                        1)
                            clear
                            echo "=============== Create New faculty  ==============="
                            view_faculty
                            create_user faculty
                            view_faculty
                            ;;
                        2)
                            clear
                            echo "=============== Create New Student  ==============="
                            view_student
                            create_user student
                            view_student
                            ;;
                        3)
                            clear
                            echo "=============== Enroll Student into Courses  ==============="
                            enroll_course
                            ;;
                        4)
                            clear
                            echo "=============== Create New Semester  ==============="
                            create_sem
                            ;;
                        5)
                            clear
                            echo "=============== Create New Course  ==============="
                            create_course
                            ;;
                        6)
                            clear
                            echo "=============== Delete Student  ==============="
                            del_stud
                            ;;
                        7)
                            clear
                            echo "=============== Modify Course Faculty  ==============="
                            modify_fac
                            ;;
                        8)
                            clear
                            echo "=============== View Faculties  ==============="
                            view_faculty
                            ;;
                        9)
                            clear
                            echo "=============== View Students  ==============="
                            view_student
                            ;;
                        10)
                            clear
                            echo "=============== View Semesters  ==============="
                            view_sem
                            ;;
                        11)
                            clear
                            echo "=============== View Courses  ==============="
                            view_course
                            ;;
                        12)
                            exit
                            ;;
                        *)
                            echo "Invalid input"
                            ;;
                    esac
                    # Ask user if they want to continue
                    echo -e "\nDo you want to continue as Admin [y/n]: "
                    read choice
                done
                echo "exit form admin"
            else
                echo "Invalid credentials"
            fi
           ;;
        2)
                choice2="y"
                while [ $choice2 == "y" ] || [ $choice2 == "Y" ]
                do
                clear
                        echo "=============== Student Menu ==============="
                        echo -e "\t\t\t\t\t "
                        echo -e "\t\t\t\t\t "
                        echo "1.Check student GRADE"
                        echo "2.Check Courses Enrolled"
                        echo "3.Check Student Attendance"
                        echo -e "\t\t\t\t\t "
                        echo -e "\t\t\t\t\t "
                        echo "=========================================="
                read choice2
                case "$choice2" in
                        1)
                                clear
                                student_grade
                                ;;
                        2)
                                clear
                                check_course
                                ;;
                        3)
                                clear
                                check_attendance
                                ;;
                        4)
                                exit
                                ;;
                        *)
                                echo "Invalid Choice"
                                ;;
                    esac
                    # Ask user if they want to continue
                    echo -e "\nDo you want to continue as student [y/n]: "
                    read choice2
                done
                    echo "exit as Student"

                ;;
        3)
                exit
                ;;
        *)
                echo "Invalid input"
                ;;
        esac
                   # Ask user if they want to continue
                    echo -e "\nDo you want to continue [y/n]: "
                    read choice1
done

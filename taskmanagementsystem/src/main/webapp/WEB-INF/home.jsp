<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>
        
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f4f4f4;
}

.container {
    width: 80%;
    max-width: 1200px;
    background: #fff;
    padding: 20px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
}

header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

header h1 {
    margin: 0;
}

header button {
    padding: 10px 20px;
    background-color: #28a745;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

main ul {
    list-style: none;
    padding: 0;
}

main ul li {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

main ul li button {
    margin-left: 10px;
    padding: 5px 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    background-color: #fff;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    max-width: 600px;
    border-radius: 8px;
}

.modal-content h2 {
    margin-top: 0;
}

.modal-content form {
    display: flex;
    flex-direction: column;
}

.modal-content form label {
    margin: 10px 0 5px;
}

.modal-content form input,
.modal-content form textarea {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.modal-content form button {
    margin-top: 20px;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.close {
    position: absolute;
    right: 20px;
    top: 20px;
    font-size: 24px;
    cursor: pointer;
}
#maincontainer{
 display:none;
}

    </style>
<body>
    
    <div class="container">
       <button id="viewtasks">view tasks</button>
       <button id="addtasks">Add Task</button>
    </div>
    
    <div id="maincontainer">
      <div id="viewtasksdiv"></div>
      <div id="adddtasksdiv" class="model">
          <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Add New Task</h2>
            <form id="addTaskForm">
                <label for="taskTitle">Title</label>
                <input type="text" id="taskTitle" required>
                <label for="taskDescription">Description</label>
                <textarea id="taskDescription" required></textarea>
                <label for="taskDueDate">Due Date</label>
                <input type="date" id="taskDueDate" required>
                <button type="submit">Add Task</button>
            </form>
        </div>
        </div>
        
        <div id="editform" >
          <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Add New Task</h2>
            <form id="edittaskform">
                <label for="taskTitle">Title</label>
                <input type="text" id="taskTitle" required>
                <label for="taskDescription">Description</label>
                <textarea id="taskDescription" required></textarea>
                <label for="taskDueDate">Due Date</label>
                <input type="date" id="taskDueDate" required>
                <button type="submit">Add Task</button>
            </form>
        </div>
      </div>
    </div>

   <script>
    $(document).ready(function(){
    	$("#addtasks").on('click',function(){
    		$("#maincontainer").show();
    		$("#viewtasksdiv").hide();
    	})
    	$("#addTaskForm").on('submit',function(event){
    		event.preventDefault();
    		
    		
    		var formData = {
                    title: $("#taskTitle").val(),
                    desc: $("#taskDescription").val(),
                    date: $("#taskDueDate").val(),
                    status:"todo"
                    
                };
    		var jsondata=JSON.stringify(formData);
    		console.log(jsondata)
    		$.ajax({
    			url:'/taskmanagementsystem/addtask',
    			type:"POST",
    			contentType:"application/json",
    			data:jsondata,
    			success:function(response){
    				alert(response);
    				$("#adddtasksdiv").hide();
    				$("#viewtasksdiv").show();
    			},
    			error:function(xhr){
    				console.log(xhr);
    			}
    			
    		})

    	});
    	
    	 $("#viewtasks").on('click', function() {
    		 $("#maincontainer").show();
    		 $("#adddtasksdiv").hide();
    		 $("#editform").hide();
    		 $("#viewtasksdiv").show();
    		 viewdata();
    		 
         });
    	 function viewdata(){
    		 $("#viewtasksdiv").empty();
    		 var data;
             $.ajax({
                 url: '/taskmanagementsystem/viewtasks',
                 type: "GET",
                 contentType: "application/json",
                 success: function(d) {
                     console.log(d);
                     data=d;
                      
                     var maindiv= $("#viewtasksdiv");
             		
            		 $.each(data, function(index, task) {
            			 
            			   var dummy=$("<div>");
            			    var titleElement = $('<h3>').text(task.title);
            			    var descElement = $('<p>').text(task.desc);
            			    var dateElement = $('<p>').text('Due date: ' + task.date);
            			    var editButton = $('<button>').text('Edit').addClass("editbtn").attr('data-id',task.sno);
            			    var deleteButton = $('<button>').text('Delete').addClass("deletebtn").attr('data-id', task.sno);
            			    dummy.append(titleElement,descElement,dateElement,editButton,deleteButton);
            			    maindiv.append(dummy);
            		    });
                 },
                 error: function(xhr) {
                     console.log(xhr);
                 }
             });
    		
    	 }
    	 $(document).on('click', '.deletebtn', function(){
    	        var taskId = $(this).attr('data-id');
    	        console.log(taskId);
    	        $.ajax({
    	            url: '/taskmanagementsystem/deletetask',
    	            type: "GET",
    	            contentType: "application/json",
    	            data: { id: taskId },
    	            success: function(response){
    	                alert("Task has been deleted");
    	                viewdata(); // Refresh the task list after deletion
    	            },
    	            error: function(xhr, status, error){
    	                alert('Failed to delete task: ' + error);
    	            }
    	        });
    	    });
    	 $(document).on('click', '.editbtn', function(){
 	        var taskId = $(this).attr('data-id');
 	        $("#viewtasksdiv").hide();
 	        $("#editform").show();
 	    });
    	 $("#edittaskform").on('submit',function(){
    		 var formData = {
    				 title: $("#taskTitle").val() ? $("#taskTitle").val() : null,
    				 desc: $("#taskDescription").val() ? $("#taskDescription").val() : null,
    				 date: $("#taskDueDate").val() ? $("#taskDueDate").val() : null,
                     status:"updated"
                 };
    		 //var jsondata=JSON.stringify(formData);
    		 $.ajax({
     			url:'/taskmanagementsystem/updatetask?Id='+taskId,
     			type:"GET",
     			contentType:"application/json",
     			data:formData,
     			success:function(response){
     				alert(response);
     				$("#editform").hide();
     				$("#viewtasksdiv").show();
     				viewdata();
     			},
     			error:function(xhr){
     				console.log(xhr);
     			}
     			
     		})
    	 })
    	 
     });
   </script>
</body>
</html>
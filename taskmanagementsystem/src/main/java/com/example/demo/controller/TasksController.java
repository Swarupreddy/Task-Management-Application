package com.example.demo.controller;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.models.*;
import com.example.demo.repository.TasksRepository;

@Controller
public class TasksController {
	
	
	@Autowired
	private TasksRepository tasksrepository;
	
	@GetMapping("/ho")
	public String gethomepage() {
		
		return "home";
	}
	
	
	@PostMapping("/addtask")
	@ResponseBody
	public String addtask(@RequestBody Tasks task) {
		System.out.print(task.toString());
		tasksrepository.save(task);
		return "added successfully";
	}
	
	@GetMapping("/viewtasks")
	@ResponseBody
	public List<Tasks> gettasks() {
		return tasksrepository.findAll();
	}
	
	@GetMapping("/deletetask")
	@ResponseBody
	public ResponseEntity<String> deletedata(@RequestParam int id){
		try {
		tasksrepository.deleteById(id);
		  return ResponseEntity.ok("data has been deleted");
		}
		catch(Exception e) {
			 return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Task not deleted");
		}		
	}
	
	@PostMapping("/updatetask")
	@ResponseBody
	public ResponseEntity<String> updatetask(@RequestParam(required=false) String title,
			@RequestParam(required=false) String desc,
			@RequestParam(required=false) String date,
			@RequestParam(required=false) String status ,
			@RequestParam int Id){
		try {
		Optional<Tasks> t=tasksrepository.findById(Id);
		Tasks task=new Tasks(); 
		if(t.isPresent()) {
			task=t.get();
		}
		String tit=null;
		if(!title.isEmpty() && title!=null) {
			tit=title; 
			task.setTitle(tit);
		}
		String des=null;
		if(!des.isEmpty() && des!=null) {
			des=desc;
			task.setDesc(des);
		}
		String newdate=null;
		if(!date.isEmpty() && date!=null) {
			// Convert string date to java.sql.Date
            Date sqlDate = Date.valueOf(date);
            task.setDate(sqlDate);
		}
		task.setStatus(status);
		tasksrepository.save(task);
		return ResponseEntity.ok("data has been updated");
		}catch(Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Task not updated");
		}
	}
}

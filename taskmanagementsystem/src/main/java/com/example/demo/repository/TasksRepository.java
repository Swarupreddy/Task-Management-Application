package com.example.demo.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.models.*;


@Repository
public interface TasksRepository extends JpaRepository<Tasks, Integer>   {

}

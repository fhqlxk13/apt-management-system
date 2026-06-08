package kr.or.ddit.domain.central.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/main")
public class CentralMainController {

    @GetMapping("/intro.do")
    public String intro() {
        return "central/service";
    }

}

pragma solidity ^0.5.0;

contract Courses {
    string public name = "Web3 Coursees";
    string public symbol = "CourseES";

    struct Course {      // 在后台存储的课程内容
        address payable publisher;
        string title;
        string content;
        string answer;
        uint price;     // 单位：wei
        uint copyrightprice;
    }

    struct CourseForPublic {     // 在前端公开的课程内容
        address payable publisher;
        string title;
        uint price;
        
        //表示course确实有这个文件
        uint courseize;
        bytes32 courseHash;
        uint copyrightprice;
    }


    event AddCourse (
        address publisher,
        uint index,
        string title,
        uint price
    );

    event BuyCourse (
        address buyer,
        uint index,
        string title
    );



    event BuyCourseCopyRight(
        address buyer, 
        address origin_owner,
        uint index,
        string title
    );

    event VerifyAnsReward(
        address buyer,
        uint index,
        string title
    );
    
    event CourseInfoChange(
        address Changer,
        uint index,
        string title,
        uint price,
        uint copyrightprice
    );
    
    uint public course_num = 0;

    // 视作加密的中心化数据库
    mapping(uint => Course) course_list;
    //视作区块链
    mapping(uint => CourseForPublic) public course_for_public_list;

    constructor() public payable {}


    // function calHashSHA256(string memory input) public returns(bytes32){
    //     bytes32 hash = sha256(input);
    //     return hash;
    // }

    function addCourse(string memory title, 
                      string memory content,
                      string memory answer,
                      uint price,
                      uint copyrightprice) public {

        Course memory new_course = Course(msg.sender, title, content, answer, price,copyrightprice);
        
        //证明此人确实有size大小，哈希值为hash的资源
        //后续框架可以改为零知识证明等方式
        bytes32 hash = sha256(abi.encode(content));
        // bytes32 hash = keccak256(abi.encode(content));
        uint coursesize = bytes(content).length;
        CourseForPublic memory new_course_for_public = CourseForPublic(msg.sender, title, price,coursesize, hash ,copyrightprice);

        course_list[course_num] = new_course;
        course_for_public_list[course_num] = new_course_for_public;
        course_num += 1;
        emit AddCourse(msg.sender, course_num-1, title, price);
    }
    

    function buyCourse(uint index) public payable returns (string memory) {
        Course memory course = course_list[index];
        // 确认买家付了正确的钱给合约，合约再付钱给卖家；否则将钱退回给买家
        if (msg.value == course.price) {

            // 抽成
            course.publisher.transfer(course.price*4/5);
            emit BuyCourse(msg.sender, index, course.title);
            return course.content;
        }
        else { 
            msg.sender.transfer(msg.value);
            return "wrong amount of ETH tokens paid!!";
        }
    }

    //买版权加入了从谁那里买来的，没用的话就删了也行
    function buyCourseCopyRight(uint index) public payable returns (string memory) {
        Course memory course = course_list[index];
        // 确认买家付了正确的钱给合约，合约再付钱给卖家；否则将钱退回给买家
        if (msg.value == course.copyrightprice) {
            //抽成
            course.publisher.transfer(course.copyrightprice*4/5);
            emit BuyCourseCopyRight(msg.sender,course.publisher, index, course.title);

            // 需要记录最初发布者吗，以及这样赋值是允许的吗
            course.publisher = msg.sender;
            return course.content;
        }

        else { 
            msg.sender.transfer(msg.value);
            return "wrong amount of ETH tokens paid!!";
        }
    }

    //判定两个字符串是否相等
    function isEqual(string memory a, string memory b) public pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        // 如果长度不等，直接返回
        if (aa.length != bb.length) return false;
        // 按位比较
        for(uint i = 0; i < aa.length; i ++) {
            if(aa[i] != bb[i]) return false;
        }
 
        return true;
    }


    function verifyAnsReward(uint index, string memory student_ans) public payable returns (string memory, uint ret_reward) {
        Course memory course = course_list[index];
        if (isEqual(student_ans,course.answer)) {
            //暂时不考虑取整截断的问题
            uint reward = course.price/10;
            msg.sender.transfer(reward);
            emit VerifyAnsReward(msg.sender, index, course.title);
            return ("RightAns, Get reward , success!",reward);
        }
        else {
            return ("wrong ans! Try again later!",0);
        }
    }


    //不可以修改内容，只能改title
    //建议加个付账才能改doge
    function courseInfoChange(
                    uint index,
                    string memory title, 
                    // string memory content,
                    string memory answer,
                    uint price,
                    uint copyrightprice) public returns (string memory) {
        
        // 这里是防止课程卖了之后等可能出现bug的情况
        if (msg.sender != course_list[index].publisher) {
            return("Not publisher, permission denied");
        }
        else{
            course_list[index].title = title;
            course_for_public_list[index].title = title;

            course_list[index].answer = answer;
            // course_for_public_list[index].answer = answer;

            course_list[index].price = price;
            course_for_public_list[index].price = price;

            course_list[index].copyrightprice = copyrightprice;
            course_for_public_list[index].copyrightprice = copyrightprice;

            emit CourseInfoChange(msg.sender,index,title,price,copyrightprice);
            return ("Successfully changed course info");
        }
    }

}
const Courses = artifacts.require('Courses')

require('chai')
  .use(require('chai-as-promised'))
  .should()


contract('Courses', ([deployer, investor]) => {
  let courses;
  before(async () => {
    courses = await Courses.new()
  })

  describe('Add a course', async () => {
    let course_title;
    let num_courses, num_courses2;
    it('add a course', async () => {
      num_courses = await courses.course_num();
      await courses.addCourse('math course', '1+1=?', '2', 10);
      num_courses2 = await courses.course_num();
      assert.equal(parseInt(num_courses2), parseInt(num_courses) + 1);
      course_title = await courses.course_for_public_list(num_courses);
      course_title = course_title.title
      assert.equal(course_title, 'math course');
    })

    // 这个测试还不能正确运行，因为Courses.sol中的buyCourse函数被我删了准备重写
    // it('buy a course', async () => {
    //   let course_content;
    //   // num_courses同时也是最后一个课程的index
    //   course_content = await courses.buyCourse(num_courses, {from: investor, value: 10});
    //   console.log("course_content:")
    //   console.log(course_content.toString());
    //   assert.equal(course_content.toString(), '1+1=?');
    // })
  })
})
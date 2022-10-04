for $x in doc("courses.xml")/courses/course
where $x/fees>5000
return $x/title

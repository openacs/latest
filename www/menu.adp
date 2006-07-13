<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Latest Menu</title>
<link href="resources/whatsnew.css" rel="stylesheet" type="text/css" />
<script src="resources/mktree.js" language="javascript"></script>
</head>

  <body>
<div id="toolbox">
<div class="title">
Latest stuff 
</div>
<div class="contents">
<span style="align:left;">
<a href="#" onClick="expandTree('tree1'); return false;">Expand all</a> | <a href="#" onClick="collapseTree('tree1'); return false;">Collapse All</a> | <a href="/dotlrn" title="Exit" target="_top">Exit</a>
</span>


	<ul class="mktree" id="tree1">
	    <li>#forums-portlet.pretty_name#

                       <ul>
                        <multiple name="forums">
			<li><a href="/o/@forums.object_id@" target="navigator">@forums.title@</a><br><i>@forums.last_modified@</i></li>
			</multiple>
                       </ul>
            </li> 
	    <li>#fs-portlet.pretty_name#
              <ul>
                        <multiple name="fs">
			<li><a href="/o/@fs.object_id@" target="navigator">@fs.title@</a> <i>@fs.last_modified@</i></li>
			</multiple>
                       </ul> 
            </li> 
           <li>#assessment.Assessments#
              <ul>
                        <multiple name="assessment_sessions">
			<li><a href="@assessment_sessions.assessment_url@"  target="navigator">@assessment_sessions.title@</a><br> <i>@assessment_sessions.publish_date@</i></li>
			</multiple>
                       </ul>
   
           </li>
            <li>#lorsm-portlet.Learning_Materials#
                      <ul>
                        <multiple name="d_courses">
			<li>@d_courses.course_url;noquote@  <br> <i>@d_courses.creation_date@</i></li>
			</multiple>

                      </ul> 
            </li> 
        </ul> 

     </div>

</div>
<br><br>
  </body>

</html>

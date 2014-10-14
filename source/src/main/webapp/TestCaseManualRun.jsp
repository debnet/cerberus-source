<%--
  ~ Cerberus  Copyright (C) 2013  vertigo17
  ~ DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
  ~
  ~ This file is part of Cerberus.
  ~
  ~ Cerberus is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ Cerberus is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with Cerberus.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@page import="org.cerberus.service.IUserSystemService"%>
<%@page import="org.cerberus.entity.SqlLibrary"%>
<%@page import="org.cerberus.service.ISqlLibraryService"%>
<%@page import="org.cerberus.entity.TestCaseCountryProperties"%>
<%@page import="org.cerberus.service.ITestCaseCountryPropertiesService"%>
<%@page import="org.cerberus.entity.TestCaseStepActionControl"%>
<%@page import="org.cerberus.entity.TestCaseStepAction"%>
<%@page import="org.cerberus.entity.TestCaseStep"%>
<%@page import="org.cerberus.service.ITestCaseStepActionControlService"%>
<%@page import="org.cerberus.service.ITestCaseStepActionService"%>
<%@page import="org.cerberus.service.ITestCaseStepService"%>
<%@page import="org.cerberus.service.ITestCaseExecutionService"%>
<%@page import="org.cerberus.entity.TestCaseExecution"%>
<%@page import="org.cerberus.service.ITestCaseCountryService"%>
<%@page import="org.cerberus.entity.TCase"%>
<%@page import="org.cerberus.service.ITestCaseService"%>
<%@page import="org.cerberus.entity.Test"%>
<%@page import="org.cerberus.service.ITestService"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.cerberus.entity.Parameter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.cerberus.entity.BuildRevisionInvariant"%>
<%@page import="org.cerberus.entity.Application"%>
<%@page import="org.cerberus.service.IDocumentationService"%>
<%@page import="org.cerberus.service.impl.BuildRevisionInvariantService"%>
<%@page import="org.cerberus.service.IBuildRevisionInvariantService"%>
<%@page import="org.cerberus.service.IApplicationService"%>
<%@page import="org.cerberus.service.IParameterService"%>
<%@page import="org.cerberus.util.StringUtil"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<% Date DatePageStart = new Date();%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta content="text/html; charset=UTF-8" http-equiv="content-type">
        <title>TestCase</title>

        <script type='text/javascript' src='js/Form_1.js'></script>
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery-migrate-1.2.1.min.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.10.2.js"></script>
        <script type="text/javascript" src="js/elrte.min.js"></script>
        <script type="text/javascript" src="js/i18n/elrte.en.js"></script>
        <script type="text/javascript" src="js/elfinder.min.js"></script>
        <script type="text/javascript" src="js/elFinderSupportVer1.js"></script>
        <link rel="stylesheet" type="text/css" href="css/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="css/elrte.min.css">
        <link rel="stylesheet" type="text/css" href="css/crb_style.css">
        <link rel="stylesheet" type="text/css" href="css/elfinder.min.css">
        <link rel="stylesheet" type="text/css" href="css/theme.css">
        <link rel="shortcut icon" type="image/x-icon" href="images/favicon.ico" />

        <script type="text/javascript">
            var displayOnlyFunctional = false;
            function showOnlyFunctional() {
                displayOnlyFunctional = !displayOnlyFunctional;
                $('.functional_description').toggleClass('only_functional_description_size');
                $('.technical_part').toggleClass('only_functional');
                SetCookie("displayOnlyFunctional", (displayOnlyFunctional ? "TRUE" : "FALSE"));
            }

            var collapseOrExpandStep = false;
            collapseOrExpandStep = !collapseOrExpandStep;
            function collapseOrExpandAllStep() {
                $('.collapseOrExpandStep').toggleClass('collapseOrExpandAllStep');
                SetCookie("collapseOrExpandStep", (collapseOrExpandStep ? "TRUE" : "FALSE"));
            }

            $().ready(function() {
                if ("TRUE" == GetCookie("displayOnlyFunctional")) {
                    showOnlyFunctional();
                }
                ;
                elRTE.prototype.options.toolbars.cerberus = ['style', 'alignment', 'colors', 'images', 'format', 'indent', 'lists', 'links'];
                var opts = {
                    lang: 'en',
                    styleWithCSS: false,
                    width: 615,
                    height: 200,
                    toolbar: 'cerberus',
                    allowSource: false,
                    cssfiles: ['css/crb_style.css'],
                    fmOpen: function(callback) {
                        $('<div />').dialogelfinder({
                            url: 'PictureConnector',
                            transport: new elFinderSupportVer1(),
                            commandsOptions: {
                                getfile: {
                                    oncomplete: 'destroy' // destroy elFinder after file selection
                                }
                            },
                            getFileCallback: callback // pass callback to file manager
                        });
                    }
                };
                var bool = $('#generalparameter').is(':visible');
                //plugin must be added with input visible - error NS_ERROR_FAILURE: Failure
                if (!bool) {
                    $('#generalparameter').show();
                }
                $('#howto').elrte(opts);
                $('#value').elrte(opts);
                $('.el-rte').css('z-index', 0);
                //plugin must be added with input visible - error NS_ERROR_FAILURE: Failure
                if (!bool) {
                    $('#generalparameter').hide();
                }
            });</script>
        <style>
            .RowActionDiv{
                display:inline-block;
                background-color: white;
            }
            .RowActionDiv:hover{
                background-color: #CCCCCC;
            }
            .RowActionDiv:focus{
                background-color: #CCCCCC;
            }
            .StepHeaderDiv {
                width:100%;
                height:40px;
                clear:both;
                display:block;
                border-style: solid;
                border-width:thin;
                border-color:#CCCCCC;
                background-image: -moz-linear-gradient(top, #ebebeb, #CCCCCC); 
                background-image: -webkit-linear-gradient(top, #ebebeb, #CCCCCC); 
                font-weight:bold;
                font-family: Trebuchet MS;
                color:#555555;
                text-align: center;

            }

            .StepHeaderContent {
                margin-top:15px; 
            }

            a:link{
                color:white;
            }



        </style>

    </head>
    <body>
        <%@ include file="include/function.jsp" %>
        <%@ include file="include/header.jsp" %>
        <div id="body">
            <%
                boolean booleanFunction = false;
                try {
                    /*
                     * Services
                     */
                    IDocumentationService docService = appContext.getBean(IDocumentationService.class);
                    IApplicationService myApplicationService = appContext.getBean(IApplicationService.class);
                    IParameterService parameterService = appContext.getBean(IParameterService.class);
                    IBuildRevisionInvariantService buildRevisionInvariantService = appContext.getBean(BuildRevisionInvariantService.class);
                    ITestService testService = appContext.getBean(ITestService.class);
                    ITestCaseService testCaseService = appContext.getBean(ITestCaseService.class);
                    ITestCaseCountryService testCaseCountryService = appContext.getBean(ITestCaseCountryService.class);
                    ITestCaseStepService tcsService = appContext.getBean(ITestCaseStepService.class);
                    ITestCaseStepActionService tcsaService = appContext.getBean(ITestCaseStepActionService.class);
                    ITestCaseStepActionControlService tcsacService = appContext.getBean(ITestCaseStepActionControlService.class);
                    ITestCaseCountryPropertiesService tccpService = appContext.getBean(ITestCaseCountryPropertiesService.class);
                    ISqlLibraryService libService = appContext.getBean(ISqlLibraryService.class);
                    ITestCaseExecutionService testCaseExecutionService = appContext.getBean(ITestCaseExecutionService.class);
                    IInvariantService invariantService = appContext.getBean(IInvariantService.class);
                    IUserSystemService userSystemService = appContext.getBean(IUserSystemService.class);

                    /**
                     * Function
                     */
                    booleanFunction = StringUtil.parseBoolean(parameterService.findParameterByKey("cerberus_testcase_function_booleanListOfFunction", "").getValue());
                    String listOfFunction = "";
                    if (booleanFunction) {
                        Parameter functions = parameterService.findParameterByKey("cerberus_testcase_function_urlForListOfFunction", "");
                        listOfFunction = functions.getValue();
                    }

                    /**
                     * String init
                     */
                    String SitdmossBugtrackingURL;
                    SitdmossBugtrackingURL = "";
                    String appSystem = "";
                    String proplist = "";

                    /*
                     * Get Parameters
                     */
                    String MySystem = request.getAttribute("MySystem").toString();
                    if (request.getParameter("system") != null && request.getParameter("system").compareTo("") != 0) {
                        MySystem = request.getParameter("system");
                    }
                    List<String> systems = new ArrayList();
                    systems.add(MySystem);

                    List<Test> tests = new ArrayList();

                    String group = getRequestParameterWildcardIfEmpty(request, "group");
                    String status = getRequestParameterWildcardIfEmpty(request, "status");
                    String test = getRequestParameterWildcardIfEmpty(request, "Test");
                    String testcase = getRequestParameterWildcardIfEmpty(request, "TestCase");
                    Boolean tinf = getBooleanParameterFalseIfEmpty(request, "Tinf");
            %>
            <input id="urlForListOffunction" value="<%=listOfFunction%>" style="display:none">
            <form action="TestCaseManualRun.jsp" method="post" name="selectTestCase" id="selectTestCase">
                <div class="filters" style="float:left; width:100%; height:30px">
                    <div style="float:left; width:60px">
                        <p class="dttTitle">Filters
                        </p>
                    </div>
                    <div style="float:left; width:100px;font-weight: bold;"><%out.print(docService.findLabelHTML("test", "test", "Test"));%>
                    </div>
                    <div style="float:left">
                        <select id="filtertest" name="Test" style="width: 200px" OnChange="document.selectTestCase.submit()">
                            <%  if (test.compareTo("") == 0) { %>
                            <option style="width: 200px" value="All">-- Choose Test --
                            </option>
                            <%  }

                                //            for (UserSystem us : userSystemService.findUserSystemByUser(request.getUserPrincipal().getName())){
                                //systems.add(us.getSystem());
                                //}
                                tests = testService.findTestBySystems(systems);
                                for (Test tst : tests) {%>
                            <option style="width: 200px;" class="font_weight_bold_<%=tst.getActive()%>" value="<%=tst.getTest()%>" <%=test.compareTo(tst.getTest()) == 0 ? " SELECTED " : ""%>><%=tst.getTest()%>
                            </option>
                            <% }
                            %>
                        </select>
                    </div>
                    <div style="float:left"><%out.print(docService.findLabelHTML("testcase", "testcase", "TestCase"));%>
                    </div>
                    <div style="float:left">
                        <select id="filtertestcase" name="TestCase" style="width: 750px" OnChange="document.selectTestCase.submit()">
                            <% if (test.compareTo("") == 0) { %>
                            <option style="width: 750px" value="All">-- Choose Test First --
                            </option>
                            <%  } else {
                                List<TCase> tcList = testCaseService.findTestCaseByTest(test);
                                for (TCase tc : tcList) {%>
                            <option style="width: 750px;" class="font_weight_bold_<%=tc.getActive()%>" value="<%=tc.getTestCase()%>" <%=testcase.compareTo(tc.getTestCase()) == 0 ? " SELECTED " : ""%>><%=tc.getTestCase()%>  [<%=tc.getApplication()%>]  : <%=tc.getShortDescription()%>
                            </option>
                            <%  }
                                } %>
                        </select>
                    </div>
                    <div style="float:left">
                        <input id="loadbutton" class="button" type="submit" name="Load" value="Load">
                    </div>
                </div>
            </form>
            <br>
            <br>
            <%if (!test.equals("") && !testcase.equals("")) {
                    TCase tcase = testCaseService.findTestCaseByKey(test, testcase);
                    Test testObject = testService.findTestByKey(test);
                    List<Invariant> countryListInvariant = invariantService.findListOfInvariantById("COUNTRY");
                    List<String> countryListTestcase = testCaseCountryService.findListOfCountryByTestTestCase(test, testcase);
                    TestCaseExecution tce = testCaseExecutionService.findLastTestCaseExecutionNotPE(test, testcase);
                    List<BuildRevisionInvariant> listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 1);
                    List<TestCaseCountryProperties> tccpList = tccpService.findDistinctPropertiesOfTestCase(test, testcase);

                    group = tcase.getGroup();
                    status = tcase.getStatus();
                    String dateCrea = tcase.getTcDateCrea() != null ? tcase.getTcDateCrea() : "-- unknown --";
                    // Define the list of country available for this test
                    String countries = "";
                    for (String c : countryListTestcase) {
                        countries += c + "-";
                    }

                    Application myApplication = null;
                    if (tcase.getApplication() != null) {
                        myApplication = myApplicationService.findApplicationByKey(tcase.getApplication());
                        appSystem = myApplication.getSystem();
                        SitdmossBugtrackingURL = myApplication.getBugTrackerUrl();
                    } else {
                        appSystem = "";
                        SitdmossBugtrackingURL = "";
                    }

                    /**
                     * We can edit the testcase only if User role is TestAdmin
                     * or if role is Test and testcase is not WORKING
                     */
                    boolean canEdit = false;
                    if (request.getUserPrincipal() != null
                            && (request.isUserInRole("TestAdmin")) || ((request.isUserInRole("Test")) && !(status.equalsIgnoreCase("WORKING")))) {
                        canEdit = true;
                    }

                    boolean canDelete = false;
                    if (request.getUserPrincipal() != null && request.isUserInRole("TestAdmin")) {
                        canDelete = true;
                    }

            %>
            <br>
            <form method="post" name="UpdateTestCase"  id="UpdateTestCase" action="UpdateTestCaseWithDependencies">
                <table id="generalparameter" class="arrond"
                       <%if (tinf == false) {%> style="display : none" <%} else {%>style="display : table"<%}%> >
                    <tr>
                        <td class="separation">
                            <table  class="wob" style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                <tr>
                                    <td colspan="2" class="wob">
                                        <h4 style="color : blue">Test Information
                                        </h4>
                                    </td>
                                    <td id="wob">
                                    </td>
                                    <td id="wob">
                                    </td>
                                    <td id="wob" align="right">
                                        <input id="button2" style="height:18px; width:10px" type="button" value="-" onclick="javascript:setInvisible();">
                                    </td>
                                </tr>    
                                <tr id="header"> 
                                    <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("test", "test", "Test"));%>
                                    </td>
                                    <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "testcase", "TestCase"));%>
                                    </td>
                                    <td class="wob" style="width: 500px"><%out.print(docService.findLabelHTML("test", "description", "Description"));%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="wob">
                                        <fieldset class="wob">
                                            <select id="informationTest" name="informationTest" style="width: 250px;background-color: #DCDCDC" OnChange="findTestcaseByTest(this.value, '', 'informationTestCase')"
                                                    readonly="readonly">
                                                <%  if (test.compareTo("") == 0) { %>
                                                <option style="width: 250px" value="All">-- Choose Test --
                                                </option>
                                                <%  }

                                                    tests = testService.getListOfTest();
                                                    for (Test tst : tests) {%>
                                                <option style="width: 250px;" class="font_weight_bold_<%=tst.getActive()%>" value="<%=tst.getTest()%>" <%=test.compareTo(tst.getTest()) == 0 ? " SELECTED " : ""%>><%=tst.getTest()%>
                                                </option>
                                                <% }
                                                %>
                                            </select>
                                            <input type="text" style="width:250px; display:none" placeholder="Select test above or define new one" id="inputAddTestInSelectTest" onchange="addOptionInSelect('inputAddTestInSelectTest', 'informationTest')"/>
                                        </fieldset>
                                        <input id="informationInitialTest" type="hidden" name="informationInitialTest" value="<%=tcase.getTest()%>">
                                    </td>
                                    <td class="wob">
                                        <fieldset class="wob">
                                            <select id="informationTestCase" name="informationTestCase" style="width: 200px; background-color: #DCDCDC" readonly="readonly">
                                                <% if (test.compareTo("") == 0) { %>
                                                <option style="width: 250px" value="All">-- Choose Test First --
                                                </option>
                                                <%  } else {
                                                    List<TCase> tcList = testCaseService.findTestCaseByTest(test);
                                                    for (TCase tc : tcList) {%>
                                                <option style="width: 250px;" class="font_weight_bold_<%=tc.getActive()%>" value="<%=tc.getTestCase()%>" <%=testcase.compareTo(tc.getTestCase()) == 0 ? " SELECTED " : ""%>><%=tc.getTestCase()%>
                                                </option>
                                                <%  }
                                                    }%>
                                            </select>
                                            <input id="inputAddTestCaseInSelectTestCase" type="text" style="width: 250px;display:none" 
                                                   placeholder="Define TestCase Identifiant different than these value" onchange="addOptionInSelect('inputAddTestCaseInSelectTestCase', 'informationTestCase')"/>
                                        </fieldset>
                                        <input id="informationInitialTestCase" type="hidden" name="informationInitialTestCase" value="<%=tcase.getTestCase()%>">
                                    </td>
                                    <td class="wob">
                                        <input id="informationTestDescription" style="width: 400px; background-color: #DCDCDC" name="informationTestDescription" readonly="readonly"
                                               value="<%=testObject.getDescription()%>">
                                    </td>                                </tr>
                            </table>
                            <br>
                            <%  if (canDelete) {%>
                            <input type="button" id="deleteTC" name="deleteTC" value="delete" onclick="javascript:deleteTestCase('<%=test%>', '<%=testcase%>', 'TestCase.jsp')">
                            <input type="button" id="exportTC" name="exportTC" value="exportTestCase" onclick="javascript:exportTestCase('<%=test%>', '<%=testcase%>', 'TestCase.jsp')">
                            <input type="button" id="saveAs" name="saveAs" value="Save As" onclick="javascript:enableDuplicateField()">
                            <input type="button" style="display:none" id="FirstSaveChanges" name="SaveChanges" value="Save Changes" onclick="$('#UpdateTestCase').submit();">
                            <div id="deleteTCDiv">
                            </div>
                            <% }%>
                        </td>
                    </tr>
                    <tr>
                        <td class="separation">
                            <table style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                <tr>
                                    <td class="wob">
                                        <table class="wob" style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                            <tr>
                                                <td class="wob" colspan="2"><h4 style="color : blue">TestCase Information</h4></td>
                                            </tr>
                                            <tr id="header">  
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "origine", "Origin"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "RefOrigine", "RefOrigine"));%></td>
                                                <td class="wob" style="width: 150px"><%out.print(docService.findLabelHTML("testcase", "TCDateCrea", "Creation date"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "Creator", "creator"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "Implementer", "implementer"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "LastModifier", "lastModifier"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("project", "idproject", "Project"));%></td>
                                                <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "ticket", "Ticket"));%></td>
                                                <td class="wob" style="width: 400px"><%out.print(docService.findLabelHTML("testcase", "Function", "Function"));%></td>
                                            </tr>
                                            <tr>
                                                <td class="wob"><input id="editOrigin" style="width: 90px;" name="editOrigin" value="<%=tcase.getOrigin()%>"></td>
                                                <td class="wob"><input id="editRefOrigin" style="width: 90px;  background-color: #DCDCDC" name="editRefOrigin" value="<%=tcase.getRefOrigin()%>"></td>
                                                <td class="wob"><%=dateCrea%></td>
                                                <td class="wob"><input readonly="readonly" id="editCreator" style="width: 90px; background-color: #DCDCDC" name="editCreator" value="<%=tcase.getCreator()%>"></td>
                                                <td class="wob"><input id="editImplementer" style="width: 90px;" name="editImplementer" value="<%=tcase.getImplementer() == null ? "" : tcase.getImplementer()%>"></td>
                                                <td class="wob"><input readonly="readonly" id="editLastModifier" style="width: 90px; background-color: #DCDCDC" name="editLastModifier" value="<%=tcase.getLastModifier()%>"></td>
                                                <td class="wob">
                                                    <% out.print(ComboProject(appContext, "editProject", "width: 90px", "editProject", "", tcase.getProject(), "", true, "", "No Project Defined."));%>
                                                </td>
                                                <td class="wob"><input id="editTicket" style="width: 90px;" name="editTicket" value="<%=tcase.getTicket() == null ? "" : tcase.getTicket()%>"></td>
                                                <td class="wob"><input id="editFunction" style="width: 390px;" list="functions" name="editFunction" value="<%=tcase.getFunction() == null ? "" : tcase.getFunction()%>"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                        </td>
                    </tr>
                    <tr>
                        <td class="separation">
                            <table style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                <tr>
                                    <td class="wob">
                                        <table class="wob" style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                            <tr><td class="wob"><h4 style="color : blue">TestCase Parameters</h4></td></tr>
                                            <tr id="header">
                                                <td class="wob" style="width: 150px"><%out.print(docService.findLabelHTML("application", "application", "Application"));%></td>
                                                <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("testcase", "ActiveQA", "RunQA"));%></td>
                                                <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("testcase", "ActiveUAT", "RunUAT"));%></td>
                                                <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("testcase", "ActivePROD", "RunPROD"));%></td>
                                                <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("invariant", "PRIORITY", "Priority"));%></td>
                                                <td class="wob" style="width: 150px"><%out.print(docService.findLabelHTML("invariant", "GROUP", "Group"));%></td>
                                                <td class="wob" style="width: 150px"><%out.print(docService.findLabelHTML("testcase", "status", "Status"));%></td>
                                                <% for (Invariant country : countryListInvariant) {%>
                                                <td class="wob" style="font-size : x-small ; width: 260px;"><%=country.getValue()%> <input type="hidden" name="testcase_country_all" value="<%=country.getValue()%>"></td>
                                                    <% } %>
                                            </tr>
                                            <tr>
                                                <td class="wob"><select id="editApplication" name="editApplication" style="width: 140px"><%
                                                    for (Application app : myApplicationService.findAllApplication()) {
                                                        %><option value="<%=app.getApplication()%>"<%=tcase.getApplication().compareTo(app.getApplication()) == 0 ? " SELECTED " : ""%>><%=app.getApplication()%></option>
                                                        <% }%>
                                                    </select></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editRunQA", "width: 75px", "editRunQA", "runqa", "RUNQA", tcase.getRunQA(), "", null)%></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editRunUAT", "width: 75px", "editRunUAT", "runuat", "RUNUAT", tcase.getRunUAT(), "", null)%></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editRunPROD", "width: 75px", "editRunPROD", "runprod", "RUNPROD", tcase.getRunPROD(), "", null)%></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editPriority", "width: 75px", "editPriority", "priority", "PRIORITY", String.valueOf(tcase.getPriority()), "", null)%></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editGroup", "width: 140px", "editGroup", "editgroup", "GROUP", group, "", null)%></td>
                                                <td class="wob"><%=ComboInvariant(appContext, "editStatus", "width: 140px", "editStatus", "editStatus", "TCSTATUS", status, "", null)%></td>
                                                <%  for (Invariant countryL : countryListInvariant) {%>
                                                <td class="wob" style="width:1px"><input value="<%=countryL.getValue()%>" type="checkbox" <% if (countryListTestcase.contains(countryL.getValue())) {%>  CHECKED  <% }%>
                                                                                         name="editTestCaseCountry" onclick="javascript:checkDeletePropertiesUncheckingCountry(this.value)"></td> 
                                                    <%} %>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <%
                                String howTo = tcase.getHowTo();
                                if (howTo == null || howTo.compareTo("null") == 0) {
                                    howTo = new String(" ");
                                } else {
                                    howTo = howTo.replace(">", "&gt;");
                                }
                                String behavior = tcase.getDescription();
                                if (behavior == null || behavior.compareTo("null") == 0) {
                                    behavior = new String(" ");
                                } else {
                                    behavior = behavior.replace(">", "&gt;");
                                }
                            %> 
                            <table>
                                <tr>
                                    <td class="wob" style="text-align: left; vertical-align : top ; border-collapse: collapse">
                                        <table class="wob"  style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                            <tr id="header">
                                                <td class="wob" style="width: 1200px"><%out.print(docService.findLabelHTML("testcase", "description", "Description"));%></td>
                                            </tr><tr>
                                                <td class="wob"><input id="editDescription" style="width: 1200px;" name="editDescription"
                                                                       value="<%=tcase.getShortDescription()%>"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr><tr>
                                    <td class="wob" style="text-align: left; vertical-align : top ; border-collapse: collapse">
                                        <table>   
                                            <tr id="header">
                                                <td class="wob" style="width: 600px"><%out.print(docService.findLabelHTML("testcase", "BehaviorOrValueExpected", "Value Expected"));%></td>
                                                <td class="wob" style="width: 600px"><%out.print(docService.findLabelHTML("testcase", "HowTo", "HowTo"));%></td>
                                            </tr>
                                            <tr>
                                                <td class="wob" style="text-align: left; border-collapse: collapse">

                                                    <textarea id="value" rows="9" style="width: 600px;" name="BehaviorOrValueExpected" value="<%=behavior.trim()%>"
                                                              onchange="trackChanges(this.value, '<%=URLEncoder.encode(behavior, "UTF-8")%>', 'submitButtonChanges')" ><%=behavior%></textarea>
                                                    <input type="hidden" id="valueDetail" name="valueDetail" value="">
                                                </td>
                                                <td class="wob">
                                                    <textarea id="howto" rows="9" style="width: 600px;" name="HowTo" value="<%=howTo.trim()%>"
                                                              onchange="trackChanges(this.value, '<%=URLEncoder.encode(howTo, "UTF-8")%>', 'submitButtonChanges')" ><%=howTo%></textarea>
                                                    <input id="howtoDetail" name="howtoDetail" type="hidden" value="" />
                                                </td>
                                            </tr>
                                        </table><br>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%  // We are getting here the last execution that was done on the testcase with its associated status.
                        String LastExeMessage;
                        LastExeMessage = "<i>Never Executed</i>";
                        if (tce != null) {
                            LastExeMessage = "Last <a width : 390px ; href=\"ExecutionDetail.jsp?id_tc=" + tce.getId() + "\">Execution</a> was ";
                            if (tce.getControlStatus().compareToIgnoreCase("OK") == 0) {
                                LastExeMessage = LastExeMessage + "<a style=\"color : green\">" + tce.getControlStatus() + "</a>";
                            } else {
                                LastExeMessage = LastExeMessage + "<a style=\"color : red\">" + tce.getControlStatus() + "</a>";
                            }
                            LastExeMessage = LastExeMessage + " in "
                                    + tce.getEnvironment() + " in "
                                    + tce.getCountry() + " on "
                                    + tce.getEnd()
                                    + "<a width : 390px ; href=\"RunTests.jsp?Test=" + test + "&TestCase=" + testcase + "&MySystem=" + appSystem
                                    + "&Country=" + tce.getCountry() + "&Environment=" + tce.getEnvironment() + "\"><i> (Run it again) </i></a>";
                        }
                        if ((tcase.getBugID() != null)
                                && (tcase.getBugID().compareToIgnoreCase("") != 0)
                                && (tcase.getBugID().compareToIgnoreCase("null") != 0)) {
                            SitdmossBugtrackingURL = SitdmossBugtrackingURL.replaceAll("%BUGID%", tcase.getBugID());
                        }
                    %>
                    <tr>
                        <td class="separation">
                            <table class="wob" style="text-align: left; border-collapse: collapse" border="0px" cellpadding="0px" cellspacing="0px">
                                <tr>
                                    <td colspan="9" class="wob">
                                        <h4 style="color : blue">Activation Criterias</h4>
                                <tr id="header">
                                    <td class="wob" style="width: 50px"><%out.print(docService.findLabelHTML("testcase", "tcactive", "Active"));%></td>
                                    <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("testcase", "FromBuild", ""));%></td>
                                    <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "FromRev", ""));%></td>
                                    <td class="wob" style="width: 90px"><%out.print(docService.findLabelHTML("testcase", "ToBuild", ""));%></td>
                                    <td class="wob" style="width: 100px"><%out.print(docService.findLabelHTML("testcase", "ToRev", ""));%></td>
                                    <td class="wob" style="width: 390px"><%out.print(docService.findLabelHTML("page_testcase", "laststatus", ""));%></td>
                                    <td class="wob" style="width: 70px"><%out.print(docService.findLabelHTML("testcase", "BugID", ""));%></td>
                                    <td class="wob" style="width: 50px"><%out.print(docService.findLabelHTML("page_testcase", "BugIDLink", ""));%></td>
                                    <td class="wob" style="width: 80px"><%out.print(docService.findLabelHTML("testcase", "TargetBuild", ""));%></td>
                                    <td class="wob" style="width: 80px"><%out.print(docService.findLabelHTML("testcase", "TargetRev", ""));%></td>
                                </tr>
                                <tr>
                                    <td class="wob"><%=ComboInvariant(appContext, "editTcActive", "width: 50px", "editTcActive", "active", "TCACTIVE", tcase.getActive(), "", null)%></td>
                                    <td class="wob">
                                        <select id="editFromBuild" name="editFromBuild" class="active" style="width: 70px" >
                                            <%  String fromBuild = ParameterParserUtil.parseStringParam(tcase.getFromSprint(), "");
                                                String fromRev = ParameterParserUtil.parseStringParam(tcase.getFromRevision(), "");
                                                String toBuild = ParameterParserUtil.parseStringParam(tcase.getToSprint(), "");
                                                String toRev = ParameterParserUtil.parseStringParam(tcase.getToRevision(), "");
                                                String targetBuild = ParameterParserUtil.parseStringParam(tcase.getTargetSprint(), "");
                                                String targetRev = ParameterParserUtil.parseStringParam(tcase.getTargetRevision(), "");
                                            %>
                                            <option style="width: 100px" value="" <%=fromBuild.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <% for (BuildRevisionInvariant myBR : listBuildRev) {%>
                                            <option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=fromBuild.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                    <td class="wob">
                                        <select id="editFromRev" name="editFromRev" class="active" style="width: 50px" >
                                            <option style="width: 100px" value="" <%=fromRev.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <%
                                                listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 2);
                                                for (BuildRevisionInvariant myBR : listBuildRev) {
                                            %><option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=fromRev.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                    <td class="wob">
                                        <select id="editToBuild" name="editToBuild" class="active" style="width: 70px" >
                                            <option style="width: 100px" value="" <%=toBuild.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <%
                                                listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 1);
                                                for (BuildRevisionInvariant myBR : listBuildRev) {
                                            %><option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=toBuild.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                    <td class="wob">
                                        <select id="editToRev" name="editToRev" class="active" style="width: 50px" >
                                            <option style="width: 100px" value="" <%=toRev.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <%
                                                listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 2);
                                                for (BuildRevisionInvariant myBR : listBuildRev) {
                                            %><option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=toRev.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% }
                                            %></select>
                                    </td>
                                    <td class="wob"><%=LastExeMessage%></td>
                                    <td class="wob"><input id="BugID" style="width: 70px;" name="editBugID" value="<%=tcase.getBugID() == null ? "" : tcase.getBugID()%>"></td>
                                    <td class="wob"><% if (tcase.getBugID() != null) {%><a href="<%= SitdmossBugtrackingURL%>"><%=tcase.getBugID()%></a><%}%></td>
                                    <td class="wob">
                                        <select id="editTargetBuild" name="editTargetBuild" class="active" style="width: 70px" >
                                            <option style="width: 100px" value="" <%=targetBuild.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <%
                                                listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 1);
                                                for (BuildRevisionInvariant myBR : listBuildRev) {
                                            %><option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=targetBuild.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                    <td class="wob">
                                        <select id="editTargetRev" name="editTargetRev" class="active" style="width: 50px" >
                                            <option style="width: 100px" value="" <%=targetRev.compareTo("") == 0 ? " SELECTED " : ""%>>----</option>
                                            <%
                                                listBuildRev = buildRevisionInvariantService.findAllBuildRevisionInvariantBySystemLevel(MySystem, 2);
                                                for (BuildRevisionInvariant myBR : listBuildRev) {
                                            %><option style="width: 100px" value="<%= myBR.getVersionName()%>" <%=targetRev.compareTo(myBR.getVersionName()) == 0 ? " SELECTED " : ""%>><%= myBR.getVersionName()%></option>
                                            <% } %>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr id ="header">
                                    <td class="wob" style="width: 650px"><%out.print(docService.findLabelHTML("testcase", "comment", "Comment"));%></td>
                                </tr>
                                <tr> 
                                    <td class="wob"><input id="comment" style="width: 1200px;" name="editComment" 
                                                           value="<%=tcase.getComment() == null ? "" : tcase.getComment()%>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%  if (canEdit) {%>
                    <tr>
                        <td class="wob">
                            <table>
                                <tr>
                                    <td class="wob"><input type="submit" name="submitInformation" value="Save TestCase Info" id="submitButtonInformation" onclick="$('#howtoDetail').val($('#howto').elrte('val'));
                                            $('#valueDetail').val($('#value').elrte('val'));"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <% }%>
                    <datalist id="functions">
                    </datalist>
                </table>
                <table id="parametergeneral" class="arrond" <%if (tinf == false) {%> style="display : table" <%} else {%>style="display : none"<%}%> >
                    <tr><td id="wob" style="width: 150px"><h4 style="color : blue">General Parameters:</h4></td>
                        <td id="wob" style="width: 150px">APP: [<%=tcase.getApplication()%>]  </td>
                        <td id="wob" style="width: 160px">GROUP: [<%=tcase.getGroup()%>]  </td>
                        <td id="wob" style="width: 200px">STATUS: [<%=tcase.getStatus()%>]  </td>
                        <td id="wob" style="width: 60px">ACT: [<%=tcase.getActive()%>]  </td>
                        <td id="wob" style="width: 170px">Last Exe: [<%=LastExeMessage%>]  </td>
                        <td id="wob" style="width: 300px">Countries: [<%=countries%>]</td>
                        <td id="wob" align="right"><input id="button1" style="height:18px; width:10px" type="button" value="+" onclick="javascript:setVisible();"></td>
                    </tr>
                </table>
                <br>
                <%
                    int size = countryListTestcase.size() * 16 + 30;
                    int size2 = 570 + 80 - size;
                    int size3 = 0;
                    int size4 = size2;

                    String color = "white";
                    int i = 1;
                    int j = 1;
                    int rowNumber = 0;
                %>
                <div id="AutomationScriptDiv" style="display : block">
                    <div id="AutomationScriptFirstLine" style="clear:both; height:30px">
                        <div id="AutomationScriptTitle" style="float:left">
                            <h3>TestCase Detailed Description</h3>
                        </div>
                        <div id="AutomationScriptFunctionalButtonDiv" style="float:left;margin-left:30px">
                            <select style="float:left; height:20px; width:100px" onchange="javascript:collapseOrExpandAllStep();">
                                <option>Full View</option>
                                <option>Show Only Step</option>
                            </select>
                        </div>
                    </div>


                    <div id="StepsMainDiv" style="width:100%;clear:both">
                        <div id="StepsDivUnderTitle" style="width:100%;clear:both">
                            <div id="StepsRightDiv" style="width:97%;float:left; margin:2%;">
                                <div id="StepNumberDiv0" style="float:left;">
                                </div>
                                <input style="display:none" value="<%=MySystem%>">
                                <%=ComboInvariant(appContext, "action_action_temp", "width: 136px; display:none", "action_action_temp", "wob", "ACTION", null, "", null)%>
                                <%=ComboInvariant(appContext, "actions_action_", "width: 150px;visibility:hidden", "actions_action_", "actions_action_", "ACTION", "", "", null)%>

                                <%
                                    int incrementStep = 0;
                                    List<TestCaseStep> tcsList = tcsService.getListOfSteps(test, testcase);
                                    for (TestCaseStep tcs : tcsList) {
                                        incrementStep++;
                                        String testForQuery = "";
                                        String testcaseForQuery = "";
                                        int stepForQuery = 0;
                                        String isReadonly = "";
                                        boolean useStep = false;
                                        boolean stepusedByAnotherTest = false;
                                        String complementName = "";

                                        List<TestCaseStep> tcsUsingThisStep = tcsService.getTestCaseStepUsingStepInParamter(test, testcase, tcs.getStep());
                                        if (!tcsUsingThisStep.isEmpty()) {
                                            stepusedByAnotherTest = true;
                                        }

                                        if (!tcs.getUseStep().equals("Y")) {
                                            testForQuery = tcs.getTest();
                                            testcaseForQuery = tcs.getTestCase();
                                            stepForQuery = tcs.getStep();
                                        } else {
                                            testForQuery = tcs.getUseStepTest();
                                            testcaseForQuery = tcs.getUseStepTestCase();
                                            stepForQuery = tcs.getUseStepStep();
                                            isReadonly = "readonly";
                                            useStep = true;
                                            complementName = "Block";
                                        }
                                        List<TestCaseStepAction> tcsaList = tcsaService.getListOfAction(testForQuery, testcaseForQuery, stepForQuery);

                                %>
                                <div id="listOfTestCaseUsingStep" style="display:none;">
                                    <%                                    if (!tcsUsingThisStep.isEmpty()) {
                                            for (TestCaseStep TcUsed : tcsUsingThisStep) {
                                    %>    
                                    <ul><%=TcUsed.getTest()%> - <%=TcUsed.getTestCase()%></ul><%    }

                                        }%>
                                </div>
                                <div style="display:block; clear:both; margin-top:5px">
                                    <div id="StepFirstLineDiv<%=incrementStep%>" class="StepHeaderDiv">
                                        <div id="StepComboDeleteDiv" style="float:left; width: 30px; text-align: center; height:100%">
                                            <a name="stepAnchor_<%=incrementStep%>"></a>
                                            <a name="stepAnchor_step<%=tcs.getStep()%>"></a>
                                            <input style="display:none" name="step_InUseInOtherTestCase_<%=incrementStep%>" value="<%=stepusedByAnotherTest ? "Y" : "N"%>">
                                            <input style="display:none" name="step_increment" value="<%=incrementStep%>">
                                            <input id="incrementStepNumber" value="<%=incrementStep%>" style="display:none">

                                        </div>
                                        <div id="StepNumberDiv" style="float:left; width:80px">
                                            &nbsp;&nbsp;Step&nbsp;&nbsp;
                                            <input value="<%=incrementStep%>" name="step_number_<%=incrementStep%>" data-fieldtype="stepNumber" style="margin-top:15px;font-weight: bold; width:20px;background-color:transparent; border-width:0px">
                                            <input type="hidden" name="initial_step_number_<%=incrementStep%>" id="initial_step_number_<%=incrementStep%>" value="<%=tcs.getStep()%>">
                                        </div>
                                        <div id="StepDescDiv" style="width:550px;float:left">
                                            <div><div><input style="float:right;margin-top:10px;font-weight: bold; width: 500px;background-color:transparent; font-weight:bold;font-size:14px ;font-family: Trebuchet MS; color:#333333; border-color:#EEEEEE;border-style:solid; border-width:thin"
                                                             data-fieldtype="Description" name="step_description_<%=incrementStep%>" value="<%=tcs.getDescription()%>">
                                                </div></div></div>
                                        <div style="float:left">
                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:green;margin-top:15px;font-weight: bold; width:20px"
                                                   value="<%=tcs.getStep()%>">
                                        </div>
                                        <div style="float:left">
                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:red;margin-top:15px;font-weight: bold; width:20px"
                                                   value="<%=tcs.getStep()%>">
                                        </div>
                                        <% if (tcs.getUseStep().equals("Y")) {%>
                                        <div id="StepUseStepDiv" style="clear:both">UseStep
                                            <input type="checkbox" name="step_useStep_<%=incrementStep%>" style="margin-top:15px;font-weight: bold; width:20px" onclick="confirmDeletingAction(this, '<%=incrementStep%>')"
                                                   <% if (tcs.getUseStep().equals("Y")) {%>
                                                   CHECKED
                                                   <%}%>
                                                   value="Y">
                                        </div>
                                        <div id="StepCopiedFromDiv" style="float:left">
                                            <p style="margin-top:15px;"> Copied from : </p>
                                        </div>
                                        <div id="StepUseStepTestDiv" style="float:left">
                                            <select id="step_useStepTest_<%=incrementStep%>" name="step_useStepTest_<%=incrementStep%>" style="width: 100px;margin-top:15px;font-weight: bold;" 
                                                    OnChange="findTestcaseByTest(this.value, '<%=MySystem%>', 'step_useStepTestCase_<%=incrementStep%>')">
                                                <%  if (tcs.getUseStepTest().equals("")) { %>
                                                <option style="width: 200px" value="All">-- Choose Test --
                                                </option>
                                                <%  }
                                                    List<Test> tList = testService.findTestBySystems(systems);
                                                    for (Test tst : tList) {%>
                                                <option style="width: 200px;" class="font_weight_bold_<%=tst.getActive()%>" value="<%=tst.getTest()%>" <%=tcs.getUseStepTest().compareTo(tst.getTest()) == 0 ? " SELECTED " : ""%>><%=tst.getTest()%>
                                                </option>
                                                <% }
                                                %>
                                            </select>
                                        </div>

                                        <div id="StepUseStepTestCaseDiv" style="float:left;">
                                            <select name="step_useStepTestCase_<%=incrementStep%>" style="width: 50px;margin-top:15px;font-weight: bold;" 
                                                    OnChange="findStepByTestCase($('#step_useStepTest_<%=incrementStep%>').val(), this.value, 'step_useStepStep_<%=incrementStep%>')"
                                                    id="step_useStepTestCase_<%=incrementStep%>">
                                                <%  if (tcs.getUseStepTestCase().equals("")) { %>
                                                <option style="width: 200px" value="All">---</option>
                                                <%  } else {
                                                    List<TCase> tcList = testCaseService.findTestCaseByTest(test);
                                                    for (TCase tc : tcList) {%>
                                                <option style="width: 200px;" class="font_weight_bold_<%=tc.getActive()%>" value="<%=tc.getTestCase()%>" <%=tcs.getUseStepTestCase().compareTo(tc.getTestCase()) == 0 ? " SELECTED " : ""%>><%=tc.getTestCase()%>
                                                </option>
                                                <% }
                                                    }%>
                                            </select>
                                        </div>
                                        <div id="StepUseStepStepDiv" style="float:left">
                                            <select name="step_useStepStep_<%=incrementStep%>" style="width: 50px;margin-top:15px;font-weight: bold;" 
                                                    id="step_useStepStep_<%=incrementStep%>" onchange="javascript:$('#UpdateTestCase').submit();">
                                                <%  if (tcs.getUseStepTest().equals("") || tcs.getUseStepTestCase().equals("")) { %>
                                                <option style="width: 200px" value="All">---</option>
                                                <%  } else {
                                                    List<TestCaseStep> tcstepList = tcsService.getListOfSteps(tcs.getUseStepTest(), tcs.getUseStepTestCase());
                                                    for (TestCaseStep tcstep : tcstepList) {%>
                                                <option style="width: 200px;" value="<%=tcstep.getStep()%>" <%=tcs.getUseStepStep().compareTo(tcstep.getStep()) == 0 ? " SELECTED " : ""%>><%=tcstep.getStep()%>
                                                </option>
                                                <% }
                                                    }%>
                                            </select>
                                        </div>
                                        <div id="StepUseStepLinkDiv" style="float:left;margin-top:15px">
                                            <a href="TestCase.jsp?Test=<%=tcs.getUseStepTest()%>&TestCase=<%=tcs.getUseStepTestCase()%>#stepAnchor_step<%=tcs.getUseStepStep()%>">Edit Used Step</a>
                                        </div>
                                        <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:green;margin-top:15px;font-weight: bold; width:20px"
                                               value="<%=tcs.getStep()%>">
                                        <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:red;margin-top:15px;font-weight: bold; width:20px"
                                               value="<%=tcs.getStep()%>">

                                        <%}%>


                                    </div>
                                    <div id="StepsBorderDiv<%=incrementStep%>" style="display:block;margin-top:0px;border-style: solid; border-width:thin ; border-color:#EEEEEE; clear:both;">
                                        <div id="StepDetailsDiv" style="clear:both">
                                            <div id="ActionControlDivUnderTitle" style="height:100%;width:100%;clear:both">
                                                <div id="Action<%=tcs.getStep()%>" class="collapseOrExpandStep"  style="height:100%; width:100%;text-align: left; clear:both" >
                                                    <div id="BeforeFirstAction<%=tcs.getStep()%>"></div>
                                                    <%
                                                        String actionColor = "";
                                                        String actionFontColor = "#333333";
                                                        int incrementAction = 0;
                                                        for (TestCaseStepAction tcsa : tcsaList) {

                                                            incrementAction++;
                                                            int b;
                                                            b = incrementAction % 2;
                                                            if (b != 1) {
                                                                //actionColor = "#f3f6fa";
                                                                actionColor = "White";
                                                            } else {
                                                                actionColor = "White";
                                                            }
                                                            if (useStep) {
                                                                actionColor = "#DCDCDC";
                                                                actionFontColor = "grey";
                                                            }
                                                    %>
                                                    <div id="StepListOfActionDiv<%=incrementStep%><%=incrementAction%>" class="RowActionDiv" style="clear:both;margin-top:0px;display:block;height:20px;width:100%;border-style: solid; border-width:thin ; border-color:#CCCCCC;">
                                                        <div name="actionRow_color_<%=incrementStep%>" style="background-color:blue; width:8px;height:100%;display:block;float:left">
                                                        </div>
                                                        <div style="display:inline-block;float:left;width:2%;height:100%;">
                                                            <input type="hidden" name="action_increment_<%=incrementStep%>" value="<%=incrementAction%>" >
                                                            <input type="hidden" name="action_step_<%=incrementStep%>_<%=incrementAction%>" data-fieldtype="stepNumber" value="<%=incrementStep%>" >
                                                        </div>
                                                        <div style="height:100%;width:4%;display:inline-block;float:left">
                                                            <input class="wob" style="width: 20px; font-weight: bold; background-color: transparent; height:100%; color:<%=actionFontColor%>"
                                                                   value="<%=incrementAction%>" data-fieldtype="action_<%=incrementStep%>" data-field="sequence"
                                                                   name="action_sequence_<%=incrementStep%>_<%=incrementAction%>" id="action_sequence_<%=incrementStep%>_<%=incrementAction%>">
                                                        </div>
                                                        <div style="height:20px;width:50%;float:left; display:inline-block">
                                                            <div class="functional_description" style="display:inline-block;clear:both;width:100%; background-color: transparent">

                                                                <div style="float:left; width:69%">
                                                                    <input class="wob" class="functional_description" data-fieldtype="Description" style="border-style:groove;border-width:thin;border-color:white;border: 1px solid white; color:#333333; width: 80%; background-color: transparent; font-weight:bold;font-size:12px ;font-family: Trebuchet MS; "
                                                                           value="<%=tcsa.getDescription()%>" placeholder="Description"
                                                                           name="action_description_<%=incrementStep%>_<%=incrementAction%>"
                                                                           id="action_description_<%=incrementStep%>_<%=incrementAction%>"<%=isReadonly%>
                                                                           onchange="showChangedRow(this.parentNode.parentNode.parentNode.parentNode)"
                                                                           >

                                                                </div>
                                                                <div class="technical_part" style="width: 30%; float:left; background-color:transparent">
                                                                    <input  class="wob property_value" style="width:80%;border-style:groove;border-width:thin;border-color:white;border: 1px solid white; background-color: transparent; color:<%=actionFontColor%>"
                                                                            value="<%=tcsa.getProperty()%>"
                                                                            <%if (useStep) {%>
                                                                            data-usestep-test="<%=testForQuery%>"
                                                                            data-usestep-testcase="<%=testcaseForQuery%>"
                                                                            data-usestep-step="<%=stepForQuery%>"
                                                                            <%}%>
                                                                            onchange="showChangedRow(this.parentNode.parentNode.parentNode.parentNode)" name="action_property_<%=incrementStep%>_<%=incrementAction%>" <%=isReadonly%>>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div style="float:left">
                                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:green;font-weight: bold; width:20px"
                                                                   value="<%=tcs.getStep()%>">
                                                        </div>
                                                        <div style="float:left">
                                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:red;font-weight: bold; width:20px"
                                                                   value="<%=tcs.getStep()%>">
                                                        </div>
                                                        <div style="background-color:blue; width:3px;height:100%;display:inline-block;float:right">
                                                        </div>

                                                    </div>

                                                    <%
                                                        List<TestCaseStepActionControl> tcsacList = tcsacService.findControlByTestTestCaseStepSequence(testForQuery, testcaseForQuery, stepForQuery, tcsa.getSequence());

                                                        int incrementControl = 0;
                                                        String controlColor = "white";
                                                        for (TestCaseStepActionControl tcsac : tcsacList) {
                                                            incrementControl++;
                                                            int e;
                                                            e = incrementControl % 2;
                                                            if (e != 1) {
                                                                controlColor = "White";
                                                            } else {
                                                                controlColor = "White";
                                                                //controlColor = "#f3f6fa";
                                                            }

                                                            if (useStep) {
                                                                controlColor = "#DCDCDC";
                                                            }
                                                    %>
                                                    <div id="StepListOfControlDiv<%=incrementStep%><%=incrementAction%><%=incrementControl%>" class="RowActionDiv" style="width:100%;height:40px;clear:both;display:block;border-style: solid; border-width:thin ; border-color:#CCCCCC;">
                                                        <div style="background-color:#33CC33; width:8px;height:100%;display:inline-block;float:left">
                                                        </div>
                                                        <div style="height:100%;width: 2%;float:left; text-align: center;">
                                                            <input type="hidden" value="<%=incrementControl%>" name="control_increment_<%=incrementStep%>_<%=incrementAction%>">
                                                            <input type="hidden" value="<%=incrementStep%>" name="control_step_<%=incrementStep%>_<%=incrementAction%>_<%=incrementControl%>" data-fieldtype="stepNumber">
                                                        </div>
                                                        <div style="width:2%;float:left;height:100%;display:inline-block">
                                                            <input data-fieldtype="ctrlseq_<%=incrementStep%>" data-field="sequence" class="wob" style="margin-top:20px;width: 20px; font-weight: bold;color:<%=actionFontColor%>"
                                                                   value="<%=incrementAction%>" name="control_sequence_<%=incrementStep%>_<%=incrementAction%>_<%=incrementControl%>">
                                                        </div>
                                                        <div style="width:2%;float:left;height:100%;display:inline-block">
                                                            <input class="wob" style="margin-top:20px;width: 20px; font-weight: bold; color:<%=actionFontColor%>"
                                                                   data-fieldtype="control_<%=incrementStep%>_<%=incrementAction%>" value="<%=incrementControl%>" name="control_control_<%=incrementStep%>_<%=incrementAction%>_<%=incrementControl%>">
                                                        </div>
                                                        <div style="height:100%;width:50%;float:left;display:inline-block">
                                                            <div class="functional_description_control" style="clear:both;width:100%;height:20px">
                                                                <div style="float:left; width:80%">
                                                                    <div style="float:left;width:80px; "><p style="float:right;font-weight:bold;color:white;" link="white" ><%out.print(docService.findLabelHTML("testcasestepaction", "description", "Description"));%></p>
                                                                    </div>
                                                                    <input class="wob" placeholder="Description" class="functional_description_control" style="border-style:groove;border-width:thin;border-color:white;border: 1px solid white; color:#333333; width: 80%; background-color: transparent; font-weight:bold;font-size:12px ;font-family: Trebuchet MS; "
                                                                           data-fieldtype="Description" value="<%=tcsac.getDescription()%>" name="control_description_<%=incrementStep%>_<%=incrementAction%>_<%=incrementControl%>" maxlength="1000">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div style="background-color:#33CC33; width:3px;height:100%;display:inline-block;float:right">
                                                        </div>
                                                        <div style="float:left">
                                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:green;margin-top:15px;font-weight: bold; width:20px"
                                                                   value="<%=tcs.getStep()%>">
                                                        </div>
                                                        <div style="float:left">
                                                            <input type="checkbox" name="step_delete_<%=incrementStep%>" style="color:red;margin-top:15px;font-weight: bold; width:20px"
                                                                   value="<%=tcs.getStep()%>">
                                                        </div>


                                                    </div>    
                                                    <%   }%>
                                                    <div id="DivActionEndOfAction<%=incrementStep%><%=incrementAction%>" class="endOfAction"></div>
                                                    <%
                                                        } /*
                                                         * End actions loop
                                                         */%>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div id="StepsEndDiv<%=incrementStep%>" style="display:none; width:100%;"></div>
                                </div>
                                <% }%>
                                <div id="wob"><h4>Properties</h4>
                                </div>
                                <div id="propertiesPartDiv">
                                    <%
                                        if (tccpList != null) {
                                    %>
                                    <table>
                                        <tr>
                                            <td id="wob" style="width:10px">
                                            </td>
                                            <td id="leftlined"  style="width:10px">
                                            </td>
                                            <td id="underlined">
                                                <table id="testcaseproperties_table" style="text-align: left; border-collapse: collapse"
                                                       border="0">
                                                    <tr id="header">
                                                        <td style="width: 30px"><%out.print(docService.findLabelHTML("page_testcase", "delete", "Delete"));%></td>
                                                        <td style="width: 100px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "property", "Property"));%></td>
                                                        <td style="width: <%=size%>px"><%out.print(docService.findLabelHTML("invariant", "country", "Country"));%></td>
                                                        <td style="width: 120px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "type", "Type"));%></td>
                                                        <td style="width: 40px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "database", "Database"));%></td>
                                                        <td style="width: <%=size2%>px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "value", "Value"));%>
                                                        <td style="width: 40px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "length", "Length"));%></td>
                                                        <td style="width: 40px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "rowlimit", "RowLimit"));%></td>
                                                        <td style="width: 80px"><%out.print(docService.findLabelHTML("testcasecountryproperties", "nature", "Nature"));%></td>
                                                    </tr>
                                                    <div id="cache_properties">
                                                        <%//ComboInvariant(appContext, "properties_dtb_type_ID", "display: none;", "properties_dtb_type_ID", "wob", "PROPERTYDATABASE", tccpList.get(0).getDatabase(), "", null)%>
                                                    </div><%

                                                        int incrementProperty = 0;
                                                        for (TestCaseCountryProperties tccp : tccpList) {
                                                            incrementProperty++;
                                                            List<String> countryOfProperty = tccpService.findCountryByProperty(tccp);

                                                            rowNumber = rowNumber + 1;
                                                            proplist = proplist + "" + tccp.getProperty() + "  /  ";

                                                            if (tccp.getType().equals("executeSqlFromLib")) {
                                                                SqlLibrary sqllib = libService.findSqlLibraryByKey(tccp.getValue1().replaceAll("'", "''"));
                                                            }

                                                            size3 = 0;
                                                            size4 = size2;
                                                            String styleValue2 = "none";
                                                            if (tccp.getType().equals("getAttributeFromHtml")
                                                                    || tccp.getType().equals("getFromXml")
                                                                    || tccp.getType().equals("getFromCookie")
                                                                    || tccp.getType().equals("getDifferencesFromXml")) {
                                                                size3 = 1 * size2 / 3;
                                                                size4 = (2 * size2 / 3) - 5;
                                                                styleValue2 = "inline";
                                                            }

                                                            int nbline = tccp.getValue1().split("\n").length;
                                                            String valueID = rowNumber + "-" + tccp.getProperty();

                                                            String showEntireValueB1 = "showEntireValueB1" + valueID;
                                                            String showEntireValueB2 = "showEntireValueB2" + valueID;
                                                            String sqlDetails = "sqlDetails" + valueID;
                                                            String sqlDetailsB1 = "sqlDetailsB1" + valueID;
                                                            String sqlDetailsB2 = "sqlDetailsB2" + valueID;
                                                            String properties_dtbID = "properties_dtb" + valueID;
                                                            i++;

                                                            j = i % 2;
                                                            if (j == 1) {
                                                                color = "#f3f6fa";
                                                            } else {
                                                                color = "White";
                                                            }
                                                    %>
                                                    <tr style="background-color : <%=color%>">
                                                        <td>
                                                            <%  if (canEdit) {%>
                                                            <input name="properties_delete_<%=incrementProperty%>" type="checkbox" style="width: 30px" value="">
                                                            <%}%>
                                                            <input type="hidden" name="property_increment" value="<%=incrementProperty%>">
                                                        </td>
                                                        <td>
                                                            <input class="wob properties_id_<%=rowNumber%> property_name" style="width: 100px; font-weight: bold; background-color : <%=color%>"
                                                                   name="properties_property_<%=incrementProperty%>" value="<%=tccp.getProperty()%>">
                                                        </td>
                                                        <td style="font-size : x-small ; width: <%=size%>px;">
                                                            <table>
                                                                <tr>
                                                                    <%  for (String c : countryListTestcase) {%>
                                                                    <td class="wob"><%=c%>
                                                                    </td> 
                                                                    <% 	} %>
                                                                </tr>
                                                                <tr>
                                                                    <%
                                                                        for (String c : countryListTestcase) {
                                                                    %>
                                                                    <td class="wob">
                                                                        <input value="<%=c%>" type="checkbox" <% if (countryOfProperty.contains(c)) {%>  CHECKED  <% }%>
                                                                               class="properties_id_<%=rowNumber%>" name="properties_country_<%=incrementProperty%>">
                                                                    </td>
                                                                    <%  }%>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td><%=ComboInvariant(appContext, "properties_type_" + incrementProperty, "width: 120px; background-color:" + color, "properties_type_" + incrementProperty, "wob", "PROPERTYTYPE", tccp.getType(), "activateDatabaseBox(this.value, 'properties_nodtb_" + incrementProperty + "' ,'properties_dtb_" + incrementProperty + "' );activateValue2(this.value, 'tdValue2_" + rowNumber + "', '" + valueID + "','" + valueID + "_2','" + size2 + "')", null)%>
                                                        </td>
                                                        <td>
                                                            <%
                                                                String displayDtbList = "";
                                                                String displayNoList = "";
                                                                if (tccp.getType().equals("executeSqlFromLib")
                                                                        || tccp.getType().equals("executeSql")
                                                                        || tccp.getType().equals("executeSoapFromLib")) {
                                                                    displayDtbList = "inline";
                                                                    displayNoList = "none";
                                                                } else {
                                                                    displayDtbList = "none";
                                                                    displayNoList = "inline";
                                                                }
                                                            %>
                                                            <%=ComboInvariant(appContext, "properties_dtb_" + incrementProperty, "width: 40px; display: " + displayDtbList + " ; background-color:" + color, "properties_dtb_" + incrementProperty, "wob", "PROPERTYDATABASE", tccp.getDatabase(), "", null)%>
                                                            <select name="properties_nodtb_<%=incrementProperty%>" style="width: 40px; display: <%=displayNoList%> ; background-color:<%=color%>" class="wob" id="properties_nodtb_<%=incrementProperty%>">
                                                                <option value="">---</option>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <table>
                                                                <tr>
                                                                    <td class="wob" rowspan="2">
                                                                        <textarea id="properties_value1_<%=incrementProperty%>" rows="2" class="wob" style="width: <%=size4%>px; background-color : <%=color%>; " 
                                                                                  name="properties_value1_<%=incrementProperty%>" value="<%=tccp.getValue1()%>"><%=tccp.getValue1()%></textarea>
                                                                    </td>
                                                                    <td class="wob" rowspan="2" style="display:<%=styleValue2%>">
                                                                        <textarea id="properties_value2_<%=incrementProperty%>" rows="2" class="wob" style="width: <%=size3%>px; background-color : <%=color%>;"
                                                                                  name="properties_value2_<%=incrementProperty%>" value="<%=tccp.getValue2()%>"><%=tccp.getValue2()%></textarea>
                                                                    </td>
                                                                    <%
                                                                        if (tccp.getType().equals("executeSqlFromLib")
                                                                                || tccp.getType().equals("executeSql")) {
                                                                    %>
                                                                    <td class="wob">
                                                                        <input style="display:inline; height:20px; width:20px; background-color: <%=color%>; color:blue; font-weight:bolder" title="Open SQL Library" class="smallbutton" type="button" value="L" name="opensql-library"  onclick="openSqlLibraryPopin('<%=valueID%>')">
                                                                    </td>
                                                                    <% }%>
                                                                    <%
                                                                        if (tccp.getType().equals("executeSqlFromLib")
                                                                                || tccp.getType().equals("executeSql")
                                                                                || tccp.getType().equals("getFromTestData")
                                                                                || tccp.getType().equals("executeSoapFromLib")) {
                                                                    %>
                                                                    <td class="wob">
                                                                        <input style="display:inline; height:20px; width:20px; background-color: <%=color%>; color:green; font-weight:bolder" title="View property" class="smallbutton" type="button" value="V" name="openview-library"  onclick="openViewPropertyPopin('<%=valueID%>', '<%=test%>', '<%=testcase%>')">
                                                                    </td>
                                                                    <%}%>
                                                                </tr>
                                                                <tr>
                                                                    <% if (nbline > 3) {%>
                                                                    <td class="wob" style="background-color: <%=color%>; text-align: center; border-left-color:white">
                                                                        <input style="display:inline; height:20px; width:20px; background-color: <%=color%>; color: green; font-weight:bolder" class="smallbutton" title="Show the Full Sql" type="button" value="+" id="<%=showEntireValueB1%>" onclick="showEntireValue('<%=valueID%>', '<%=nbline%>', '<%=showEntireValueB1%>', '<%=showEntireValueB2%>');">
                                                                        <input style="display:none; height:20px; width:20px; background-color: <%=color%>; color: red; font-weight:bolder" class="smallbutton" title="Hide Details" type="button" value="-" id="<%=showEntireValueB2%>" onclick="showLessValue('<%=valueID%>', '<%=showEntireValueB1%>', '<%=showEntireValueB2%>');">
                                                                    </td>
                                                                    <%} else {%>
                                                                    <td class="wob" style="background-color: <%=color%>; text-align: center; border-left-color:white">
                                                                        <% if (tccp.getType().equals("executeSqlFromLib")) {%>
                                                                        <input style="display:inline; height:20px; width:20px; background-color: <%=color%>; color: orange; font-weight:bolder" class="smallbutton" type="button" value="e" title="Show the SQL" id="<%=sqlDetailsB1%>" onclick="showSqlDetails('<%=sqlDetails%>', '<%=sqlDetailsB1%>', '<%=sqlDetailsB2%>');">
                                                                        <input style="display:none; height:20px; width:20px; background-color: <%=color%>; color: orange; font-weight:bolder" class="smallbutton" type="button" value="-" title="Hide the SQL" id="<%=sqlDetailsB2%>" onclick="hideSqlDetails('<%=sqlDetails%>', '<%=sqlDetailsB1%>', '<%=sqlDetailsB2%>');">
                                                                        <% } %>
                                                                    </td>
                                                                    <% }%>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td>
                                                            <input class="wob" style="width: 40px; background-color : <%=color%>" name="properties_length_<%=incrementProperty%>"
                                                                   value="<%=tccp.getLength()%>" onchange="trackChanges(this.value, '<%=tccp.getLength()%>', 'SavePropertyChanges')">
                                                        </td>
                                                        <td>
                                                            <input class="wob" style="width: 40px; background-color : <%=color%>" name="properties_rowlimit_<%=incrementProperty%>"
                                                                   value="<%=tccp.getRowLimit()%>" onchange="trackChanges(this.value, '<%=tccp.getRowLimit()%>', 'SavePropertyChanges')">
                                                        </td>
                                                        <td><%=ComboInvariant(appContext, "properties_nature_" + incrementProperty, "width: 80px; background-color:" + color, "properties_nature_" + incrementProperty, "wob", "PROPERTYNATURE", tccp.getNature(), "trackChanges(0, this.selectedIndex, 'submitButtonChanges')", null)%></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                                <br>
                                                <%  if (canEdit) {%>
                                                <input type="button" value="Add Property" id="AddProperty"
                                                       onclick="addTestCasePropertiesNew('testcaseproperties_table', <%=rowNumber%>, <%=size%>, <%=size2%>);">
                                                <input type="submit" value="Save Changes" id="SavePropertyChanges">              
                                                <input type="hidden" id="Test" name="Test" value="<%=test%>">
                                                <input type="hidden" id="TestCase" name="TestCase" value="<%=testcase%>">
                                                <input type="hidden" name="testcase_hidden" value="<%=test + " - " + testcase%>">
                                                <input type="hidden" id="CountryList" name="CountryList" value="<%=countries%>">
                                                <%=ComboInvariant(appContext, "new_properties_type_new_properties_value", "width: 70px;visibility:hidden", "new_properties_type_new_properties_value", "new_properties_type_new_properties_value", "PROPERTYTYPE", "", "", null)%>
                                                <%=ComboInvariant(appContext, "properties_dtb_", "width: 40px;visibility:hidden", "properties_dtb_", "properties_dtb_", "PROPERTYDATABASE", "", "", null)%>
                                                <%=ComboInvariant(appContext, "properties_nature_", "width: 80px;visibility:hidden", "properties_nature_", "properties_nature_", "PROPERTYNATURE", "", "", null)%>
                                                <input type="hidden" name="testcase_hidden" value="<%=test + " - " + testcase%>">
                                                <input type="hidden" name="testcase_country_hidden" value="<%=countries%>">
                                                <% }%>
                                            </td>
                                        </tr>
                                    </table>
                                    <p id="hiddenProperty" style="font-size : x-small ; width: <%=size%>px; visibility:hidden">
                                        <% for (String c : countryListTestcase) {%>
                                        <%=c%> 
                                        <% } %>
                                        <br>
                                        <% for (String c : countryListTestcase) {
                                        %>
                                        <input data-country="ctr" value="<%=c%>" type="checkbox" id="properties_country" 
                                               name="properties_country" >
                                        <% } %>
                                    </p>
                                    <%
                                    } else {
                                    %>
                                    <table id="nocountrydefined" class="arrond">
                                        <tr>
                                            <td class="wob"></td>
                                        </tr>
                                        <tr>
                                            <td class="wob">
                                                <h3> To add Properties,Actions and controls, select at least one country in the general parameters </h3>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="wob"></td>
                                        </tr>
                                    </table>
                                    <%   } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <br>
            <table id="arrond" style="text-align: left" border="1" >
                <tr>
                    <td colspan="3">
                        <h4>Contextual Actions</h4>
                    </td>
                </tr>
                <tr>
                    <% if (tcase.getGroup().equalsIgnoreCase("AUTOMATED")) {%>
                    <td>
                        <a href="RunTests.jsp?Test=<%=test%>&TestCase=<%=testcase%>&MySystem=<%=appSystem%>">Run this Test Case.</a>
                    </td>
                    <%        } else if (tcase.getGroup().equalsIgnoreCase("MANUAL")) {%>
                    <td>
                        <a href="RunManualTestCase.jsp?Test=<%=test%>&TestCase=<%=testcase%>&MySystem=<%=appSystem%>">Run this Test Case.</a>
                    </td>
                    <%        }%>    
                    <td>
                        <a href="ExecutionDetailList.jsp?test=<%=test%>&testcase=<%=testcase%>&MySystem=<%=appSystem%>">See Last Executions..</a>
                    </td>
                    <%if (request.getUserPrincipal()
                                != null && request.isUserInRole("TestAdmin")) {
                    %>
                    <td>
                        <a href="LogViewer.jsp?Test=<%=test%>&TestCase=<%=testcase%>">See Log Viewer...</a>
                    </td>
                    <% }%>
                </tr>
            </table>
            <%
                    }
                } catch (Exception e) {
                    out.println("<br> error message : " + e.getMessage() + " " + e.toString() + "<br>");
                }
            %>
        </div>
        <script>
            function showTestCaseUsingThisStep() {
                $("#listOfTestCaseUsingStep").dialog({
                    width: "800",
                    height: "600",
                    buttons: {
                        "OK": function() {
                            $(this).dialog("close");
                        }
                    }
                });
            }
        </script>
        <script>
            function showChangedRow(row) {
                $(row).css('background-color', '#FFEBC4');
            }
        </script>
        <script>
            $(document).ready(function() {
                return callEvent();
            });

            function callEvent() {
                $("input[data-fieldtype='Description']").each(function(index, field) {
                    $(field).off('keydown');
                    $(field).on('keydown', function(e) {
                        if (e.which === 67 && e.altKey) {
                            var f = $(field).parent().parent().parent().parent();
                            f.find('img[data-fieldtype="addActionButton"]').click();
                            f.nextUntil('.RowActionDiv').next().find("input[data-fieldtype='Description']").focus();

                        }
                        if (e.which === 86 && e.altKey) {
                            var f = $(field).parent().parent().parent().parent();
                            f.find('img[data-fieldtype="addControlButton"]').click();
                            f.next().find("input[data-fieldtype='Description']").focus();

                        }
                    });
                });
            }</script>
        <div id="popin"></div>
        <br><% out.print(display_footer(DatePageStart));%>
    </body>
</html>
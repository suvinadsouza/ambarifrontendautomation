import java.io.FileReader;
import java.io.IOException;

import jxl.read.biff.BiffException;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.firefox.internal.ProfilesIni;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import AmbariPageObjects.AssignMasters;
import AmbariPageObjects.AssignSlavesAndClients;
import AmbariPageObjects.ChooseServices;
import AmbariPageObjects.ConfirmHosts;
import AmbariPageObjects.CustomizeServices;
import AmbariPageObjects.Deploy;
import AmbariPageObjects.GetStarted;
import AmbariPageObjects.InstallOptions;
import AmbariPageObjects.LaunchInstallWizard;
import AmbariPageObjects.SelectVersion;

import com.opencsv.CSVParser;
import com.opencsv.CSVReader;


//import the page objects


public class AmbariFrontEndInstallPogram 
{
	
	//variables
	static String protocol;
	static String ambariserver_fqdn;
	static String port;
	static String cluster_name;
	static String major_version;
	static String minor_version;
	static String hostnames;
	static String sshkey;
	static String sshuser;
	static String deselect_services;
	static String component_hosts;
	static String hdfs_namenode_dirs;
	static String hdfs_datanode_dirs;
	static String hive_password;
	static String knox_password;
	static String ambarimetrics_password;
	static String oozie_password;
	static String smartsense_password;
	static String ldap;
	static String seleniumFFProfileName;
	static String firefoxGeckoDriverPath;
	static CharSequence[] searchstring = null;
										
	//default start program
	public static void main(String[] args) throws IOException, InterruptedException, BiffException
	{
		
		//declare variables
		String csvfile = "ambari_options.csv";
		CSVReader csvfilereader = new CSVReader(new FileReader(csvfile),CSVParser.DEFAULT_SEPARATOR, CSVParser.DEFAULT_QUOTE_CHARACTER, 1);
		
		while((searchstring = csvfilereader.readNext()) != null)//start of while
		{

			//assign csv file values to variables
			protocol=searchstring[0].toString();
			ambariserver_fqdn=searchstring[1].toString();
			port=searchstring[2].toString();
			cluster_name=searchstring[3].toString();
			major_version=searchstring[4].toString();
			minor_version=searchstring[5].toString();
			hostnames=searchstring[6].toString();
			sshkey=searchstring[7].toString();
			sshuser=searchstring[8].toString();
			deselect_services=searchstring[9].toString();
			component_hosts=searchstring[10].toString();
			hdfs_namenode_dirs=searchstring[11].toString();
			hdfs_datanode_dirs=searchstring[12].toString();
			hive_password=searchstring[13].toString();
			knox_password=searchstring[14].toString();
			ambarimetrics_password=searchstring[15].toString();
			oozie_password=searchstring[16].toString();
			smartsense_password=searchstring[17].toString();
			ldap=searchstring[18].toString();
			seleniumFFProfileName=searchstring[19].toString();
			firefoxGeckoDriverPath=searchstring[20].toString();
			
			
			System.out.println("protocol:"+protocol+" "+"ambari server:"+ambariserver_fqdn+" "+"port:"+port+" ");
			System.out.println("clustername:"+cluster_name+" "+"majorversion:"+major_version+" "+"minorversion:"+minor_version+" ");
			System.out.println("hostname:"+hostnames+" "+"sshkey:"+sshkey+" "+"sshuser:"+sshuser+" ");
			System.out.println("services to deselect:"+deselect_services+" "+"component hosts:"+component_hosts+" "+"hdfs namenode dirs"+hdfs_namenode_dirs+" ");
			System.out.println("ambari metrics passwd:"+ambarimetrics_password+" "+"oozie password:"+oozie_password+" "+"smartsense password"+smartsense_password+" "+"ldap:"+ldap);
			System.out.println("selenium profile path: "+seleniumFFProfileName);
			System.out.println("firefox gecko driver path: "+firefoxGeckoDriverPath);

			//use chrome
			/*System.setProperty("webdriver.chrome.driver", "D:\\softwares\\selenium\\chromedriver_win32\\chromedriver.exe");
			WebDriver driver = new ChromeDriver();*/
			
			
			//use firefox		
			System.setProperty("webdriver.gecko.driver", "geckodriver.exe");
			ProfilesIni browserProfile = new ProfilesIni();
			FirefoxProfile ffProfile = browserProfile.getProfile(seleniumFFProfileName);
			ffProfile.setAcceptUntrustedCertificates(true);
			ffProfile.setAssumeUntrustedCertificateIssuer(false);
			WebDriver driver = new FirefoxDriver();
			
						
			//wait for elements on page
			WebDriverWait wait = new WebDriverWait(driver, 120);

			//open the chrome browser
			driver.manage().deleteAllCookies();
			driver.get(protocol+":"+"//"+ambariserver_fqdn+":"+port);
			Thread.sleep(2000);
			driver.manage().window().maximize();
		
			//login with admin/admin
			wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[class=\"ember-view ember-text-field login-user-name span4\"]")));
			wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[class=\"ember-view ember-text-field login-user-password span4\"]")));
			wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("button[class=\"btn btn-success login-btn")));
		
			if(driver.findElement(By.cssSelector("button[class=\"btn btn-success login-btn")).isEnabled())
			{
				driver.findElement(By.cssSelector("input[class=\"ember-view ember-text-field login-user-name span4\"]")).clear();
				driver.findElement(By.cssSelector("input[class=\"ember-view ember-text-field login-user-name span4\"]")).sendKeys("admin");
				driver.findElement(By.cssSelector("input[class=\"ember-view ember-text-field login-user-password span4\"]")).clear();
				driver.findElement(By.cssSelector("input[class=\"ember-view ember-text-field login-user-password span4\"]")).sendKeys("admin");
				driver.findElement(By.cssSelector("button[class=\"btn btn-success login-btn")).click();
			}
		
			//call LaunchInstallWizard
			Thread.sleep(2000);
			LaunchInstallWizard LaunchInstallWizardPageObj = PageFactory.initElements(driver, LaunchInstallWizard.class);
			Thread.sleep(5000);
			LaunchInstallWizardPageObj.LaunchInstallWizardProcess(protocol+":"+"//"+ambariserver_fqdn+":"+port);
			Thread.sleep(2000);
		
			//call GetStarted
			GetStarted GetStartedPageObj = PageFactory.initElements(driver, GetStarted.class);
			GetStartedPageObj.GetStartedProcess(cluster_name);
			Thread.sleep(2000);
		
			//call SelectVersion
			SelectVersion SelectVersionPageObj = PageFactory.initElements(driver, SelectVersion.class);
			Thread.sleep(3000);
			SelectVersionPageObj.SelectVersionProcess(major_version,minor_version);
			Thread.sleep(2000);
		
			//call InstallOptions
			InstallOptions InstallOptionsPageObj = PageFactory.initElements(driver, InstallOptions.class);
			Thread.sleep(2000);
			/*Workbook wb = Workbook.getWorkbook(new File(sshkey));
			Sheet sh = wb.getSheet(0); 
			String sshkeyContent = sh.getCell(0,0).getContents();*/
			InstallOptionsPageObj.InstallOptionsProcess(hostnames,sshkey,sshuser);
			Thread.sleep(2000);
		
			//call ConfirmHosts
			ConfirmHosts ConfirmHostsPageObj = PageFactory.initElements(driver, ConfirmHosts.class);
			Thread.sleep(2000);
			int response= ConfirmHostsPageObj.ConfirmHostsProcess();
			Thread.sleep(2000);
			if(response == 1)
			{
				System.out.println("Confirm hosts has passed");
			
				//call ChooseServices
				ChooseServices ChooseServicesPageObj = PageFactory.initElements(driver, ChooseServices.class);
				Thread.sleep(2000);
				ChooseServicesPageObj.ChooseServicesProcess(deselect_services);
				Thread.sleep(2000);
			
				//call AssignMasters
				AssignMasters AssignMastersPageObj = PageFactory.initElements(driver, AssignMasters.class);
				Thread.sleep(2000);
				AssignMastersPageObj.AssignMastersProcess(component_hosts);
				Thread.sleep(2000);
			
				//call AssignSlaves & Clients
				AssignSlavesAndClients AssignSlavesAndClientsPageObj = PageFactory.initElements(driver, AssignSlavesAndClients.class);
				Thread.sleep(2000);
				AssignSlavesAndClientsPageObj.AssignSlavesAndClientsProcess();
				Thread.sleep(2000);
			
				//call customize services
				CustomizeServices CustomizeServicesPageObj = PageFactory.initElements(driver, CustomizeServices.class);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessHDFS(hdfs_namenode_dirs,hdfs_datanode_dirs);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessHive(hive_password);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessKnox(knox_password);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessAmbariMetrics(ambarimetrics_password);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessOOzie(oozie_password);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessSmartSense(smartsense_password);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesProcessMisc(ldap);
				Thread.sleep(2000);
				CustomizeServicesPageObj.CustomizeServicesCompleteProcess();
				}
				
			//call Deploy
			Deploy DeployPageObj = PageFactory.initElements(driver, Deploy.class);
			Thread.sleep(2000);
			DeployPageObj.DeployAmbari();
			Thread.sleep(2000);
			
			
		
		}//end of while
		
		//close the csv reader and delete all cookies
		csvfilereader.close();
		Thread.sleep(2000);
		
		
	}

}

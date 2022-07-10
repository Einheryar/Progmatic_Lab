#JiraBot Parser v.1.0. 10.07.2022, Author: Sergey Sorokin (witchking@mail.ru)
$pathToSourceFile = "D:\...\jirabot.txt"
$pathToOutputFile = "D:\...\jirabot.csv"

$input = [System.IO.StreamReader]::new($pathToSourceFile)

$array = @()

$firstTask = $true
$isStatus = $false
$line = ""

$taskHashtable = @{
	ID = ""
	Datetime = ""
	Author = ""
	Action = ""
	URL = ""
	Subject = ""
	Body = ""
	Status = ""
}

echo "Start"

for() {
	$line = $input.ReadLine()
	
	if ($null -eq $line) {
		break
    }
	
	if ("" -eq $line) {
		continue
	}

	if ($line.Contains('JiraBot')) {
		$isStatus = $false
				
		if ($false -eq $firstTask) {
			$isStatus = $false

			$task_Body = $task_Body.Trim("`n")
			$task.Body = $task_Body

			$array += $task
			echo "`n"
			echo "Task ID: $task_ID"
			echo "Task DateTime: $task_datetime"
			echo "Task Author: $task_author"
			echo "Task Action: $task_action"
			echo "Task URL: $task_URL"
			echo "Task Subject: $task_Subject"
			echo "Task Body: $task_Body"
			echo "Task Status: $task_Status"
		} else {
			$firstTask = $false
		}
		
		$task = [pscustomobject]$taskHashtable
			
		$task_datetime = $line
		$task_author = ""
		$task_action = ""
		$task_ID = ""
		$task_URL = ""
		$task_Subject = ""
		$task_Body = ""
		$task_Status = ""
		
		$task.Datetime = $task_datetime.Split('(')[1].Split(')')[0]
		$task_datetime = $task.Datetime
		
		$line = $input.ReadLine()
		
		if ($null -eq $line) {
			break
		}
			
		$task_tmp1 = 0
		$task_tmp2 = 0
		$task_tmp3 = 0
		$task_tmp4 = 0
		$task_tmpStr1 = ""
		$task_tmpStr2 = ""
		$task_tmpStr3 = ""
			
		$task_tmp1 = $line.IndexOf("VKCS-")
		$task_tmpStr1 = $line.Substring(0, $task_tmp1 - 1)
		
		$task_tmp2 = $line.IndexOf(" запрос")
		if (-1 -eq $task_tmp2) {
			$task_tmp2 = $line.IndexOf(" прокомментировал")
			$task_tmp3 = $task_tmp2
		} else {
			$task_tmpStr2 = $line.Substring(0, $task_tmp2)
		
			$task_tmp3 = $task_tmpStr2.LastIndexOf(" ")
		}

		$task.Author = $line.Substring(0, $task_tmp3)
		$task_author = $task.Author
		
		$task_tmp4 = $line.IndexOf("VKCS-")
		$task.Action = $line.Substring($task_tmp3 + 1, $task_tmp4 - $task_tmp3 - 2)
		$task_action = $task.Action

		$task.ID = $line.Substring($task_tmp4, 10)
		$task_ID = $task.ID
		
		$task.URL = "https://jira.vk.team/browse/$task_ID"
		$task_URL = $task.URL
		
		$line = $input.ReadLine()
		
		if ($null -eq $line) {
			break
		}

		$task.Subject = $line
		$task_Subject = $task.Subject
	} else {
		if ($true -eq $isStatus) {
			continue
		}
		
		if ($line.Contains('Статус:')) {
			$isStatus = $true
			
			$task_Body = $task.Body
			
			$task_tmp5 = 0
			$task_tmpStr5 = ""
			
			$task_tmp5 = $line.IndexOf(" ")
			$task.Status = $line.Substring($task_tmp5, $line.Length - $task_tmp5)
			$task_Status = $task.Status
		} else {
			$task_Body = $task.Body
			$task.Body = [string]::Concat($task_Body, "`n", $line)
			$task_Body = $task.Body
		}
	}
}

if ($false -eq $isStatus) {
	$task_Body = $task_Body.Trim("`n")
	$task.Body = $task_Body
	
	$array += $task

	echo "`n"
	echo "Task ID: $task_ID"
	echo "Task DateTime: $task_datetime"
	echo "Task Author: $task_author"
	echo "Task Action: $task_action"
	echo "Task URL: $task_URL"
	echo "Task Subject: $task_Subject"
	echo "Task Body: $task_Body"
	echo "Task Status: $task_Status"
}

#$array | Export-Csv -path D:\Work\Progmatic_Lab\Scripts\JiraBot\test8.csv -NoType -UseCulture -Encoding UTF8
$array | Export-Csv -path $pathToOutputFile -NoType -UseCulture -Encoding UTF8

$input.Close()
echo "End"

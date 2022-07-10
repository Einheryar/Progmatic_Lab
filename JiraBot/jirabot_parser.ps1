$input = [System.IO.StreamReader]::new("D:\Work\Progmatic_Lab\Scripts\JiraBot\jirabot_test8.txt")

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
		#echo "EMPTY_LINE"
		continue
	}

	#$line
	
	if ($line.Contains('JiraBot')) {
		#echo "Это первая строка задачи!"
		$isStatus = $false
				
		if ($false -eq $firstTask) {
			#echo "`nЗапись объекта в массив (JiraBot):"
			#$task
			
			$isStatus = $false

			$task_Body = $task_Body.Trim("`n")
			$task.Body = $task_Body

			$array += $task
			#echo "Запись объекта в массив завершена!`n"
			#echo "Array: "
			#$array
			
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
		#echo "Task DateTime: $task_datetime"
		
		$line = $input.ReadLine()
		
		if ($null -eq $line) {
			break
		}
			
		#$line
		#echo "Это вторая строка задачи!"
		
		$task_tmp1 = 0
		$task_tmp2 = 0
		$task_tmp3 = 0
		$task_tmp4 = 0
		$task_tmpStr1 = ""
		$task_tmpStr2 = ""
		$task_tmpStr3 = ""
			
		$task_tmp1 = $line.IndexOf("VKCS-")
		$task_tmpStr1 = $line.Substring(0, $task_tmp1 - 1)
		#echo $task_tmpStr1
		
		$task_tmp2 = $line.IndexOf(" запрос")
		if (-1 -eq $task_tmp2) {
			#echo "В строке нет слова 'запрос'"
			$task_tmp2 = $line.IndexOf(" прокомментировал")
			$task_tmp3 = $task_tmp2
		} else {
			#echo $task_tmp2
			$task_tmpStr2 = $line.Substring(0, $task_tmp2)
			#echo $task_tmpStr2
		
			$task_tmp3 = $task_tmpStr2.LastIndexOf(" ")
		}

		$task.Author = $line.Substring(0, $task_tmp3)
		$task_author = $task.Author
		#echo "Task Author: $task_author"
		
		$task_tmp4 = $line.IndexOf("VKCS-")
		$task.Action = $line.Substring($task_tmp3 + 1, $task_tmp4 - $task_tmp3 - 2)
		$task_action = $task.Action
		#echo "Task Action: $task_action"

		$task.ID = $line.Substring($task_tmp4, 10)
		$task_ID = $task.ID
		#echo "Task ID: $task_ID"
		
		$task.URL = "https://jira.vk.team/browse/$task_ID"
		$task_URL = $task.URL
		#echo "Task URL: $task_URL"
		
		$line = $input.ReadLine()
		
		if ($null -eq $line) {
			break
		}

		#$line
		#echo "Это третья строка задачи!"
		$task.Subject = $line
		$task_Subject = $task.Subject
		#echo "Task Subject: $task_Subject"
		#echo "Конец обработки строки с JiraBot"
	} else {
		#echo "Это следующая строка задачи!"
		if ($true -eq $isStatus) {
			#$isStatus
			#echo "PAST_STATUS"
			continue
		}
		
		if ($line.Contains('Статус:')) {
			$isStatus = $true
			#$isStatus
			
			$task_Body = $task.Body
			#echo "Task Body-Status: $task_Body"
			
			$task_tmp5 = 0
			$task_tmpStr5 = ""
			
			$task_tmp5 = $line.IndexOf(" ")
			$task.Status = $line.Substring($task_tmp5, $line.Length - $task_tmp5)
			$task_Status = $task.Status
			#echo "Task Status: $task_Status"
		} else {
			$task_Body = $task.Body
			$task.Body = [string]::Concat($task_Body, "`n", $line)
			$task_Body = $task.Body
			#echo "Task Body-Other: $task_Body"
		}
	}
}

if ($false -eq $isStatus) {
	#echo "`nЗапись объекта в массив (Status):"
	#$task
	$task_Body = $task_Body.Trim("`n")
	$task.Body = $task_Body
	
	$array += $task
	#echo "Запись объекта в массив завершена!`n"
	#echo "Array: "
	#$array

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

#$isStatus

$array | Export-Csv -path D:\Work\Progmatic_Lab\Scripts\JiraBot\test8.csv -NoType -UseCulture -Encoding UTF8

$input.Close()
echo "End"

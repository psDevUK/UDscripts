<#
.Synopsis
   Uses the Davinci ChatGPT model to provide answers to IT questions
.DESCRIPTION
   Designed with pre-generated prompts to enable the AI chatbot to get a better understanding of what you want to ask it. When you select a theme you will see the prompt box generated with the text used for that AI prompt, you just need to then type your question after the prompt. You can edit the prompt as you see fit.
.EXAMPLE
   Invoke-WorkAI -MaxTokens 500 -Temperature 0.2
.EXAMPLE
   Invoke-WorkAI -MaxTokens 850 -Temperature 0.9
#>
function Invoke-WorkAI { 
    # Define parameters for script
    param (
	#Enter Your API KEY HERE
        [string]$ApiKey,
        [int]$MaxTokens = 500,
        [decimal]$Temperature = 0.5
    )
    
    #region Function Global State
    function Get-Prompt {
        param (
            [string]$selectedTheme
        )
    
        $selectedPrompt = $customObject | Where-Object { $_.theme -eq $selectedTheme } | Select-Object -ExpandProperty prompt
        return "$selectedTheme `n $selectedPrompt"
    }
    # Define global variables to store conversation state
    $global:conversationState = @{
        selectedTheme = ""
        messages      = @()
    }
    #endregion
    
    #region HashTable data
    $hashTable = @(
        @{
            theme  = "Chief Executive Officer";
            prompt = "I want you to act as a Chief Executive Officer for a hypothetical company. You will be responsible for making strategic decisions, managing the company\u0027s financial performance, and representing the company to external stakeholders. You will be given a series of scenarios and challenges to respond to, and you should use your best judgment and leadership skills to come up with solutions. Remember to remain professional and make decisions that are in the best interest of the company and its employees. Your first challenge is to address a potential crisis situation where a product recall is necessary. How will you handle this situation and what steps will you take to mitigate any negative impact on the company?"
        },
        @{
            theme  = "Cyber Security Specialist";
            prompt = "I want you to act as a cyber security specialist. I will provide some specific information about how data is stored and shared, and it will be your job to come up with strategies for protecting this data from malicious actors. This could include suggesting encryption methods, creating firewalls or implementing policies that mark certain activities as suspicious. My first request is:"
        },
        @{
            theme  = "Developer Relations consultant";
            prompt = "I want you to act as a Developer Relations consultant. I will provide you with a software package and related documentation. Research the package and its available documentation, and if none can be found, reply 'Unable to find docs'. Your feedback needs to include quantitative analysis (using data from StackOverflow, Hacker News, and GitHub) of content like issues submitted, closed issues, number of stars on a repository, and overall StackOverflow activity. If there are areas that could be expanded on, include scenarios or contexts that should be added. Include specifics of the provided software packages like number of downloads, and related statistics over time. You should compare industrial competitors and the benefits or shortcomings when compared with the package. Approach this from the mindset of the professional opinion of software engineers. Review technical blogs and websites (such as TechCrunch.com or Crunchbase.com) and if data is not available, reply 'No data available'. My first request is:"
        },
        @{
            theme  = "Fullstack Software Developer";
            prompt = "I want you to act as a software developer. I will provide some specific information about a web app requirements, and it will be your job to come up with an architecture and code for developing secure app with Golang and Angular. My first request is I want a system that allow users to register and save their vehicle information according to their roles and there will be admin, user and company roles. I want the system to use JWT for security"
        },
        @{
            theme  = "Google-Fu Generator";
            prompt = "I want you to act as a google search advisor. As in I will tell you what I want to search the internet for, and you will design a search query to enter into google.com but I want you to provide as many advanced search operators in your search query you provide. I want the search result to limit the amount of webpages retrieved and to be a specific to my request as possible using advanced search operators. My search query is:"
        },
        @{
            theme  = "IT Architect";
            prompt = "I want you to act as an IT Architect. I will provide some details about the functionality of an application or other digital product, and it will be your job to come up with  ways to integrate it into the IT landscape. This could involve analyzing business requirements, performing a gap analysis and mapping the functionality of the new system to the existing IT landscape. Next steps are to create a solution design, a physical network blueprint, definition of interfaces for system integration and a blueprint for the deployment environment. My first request is:"
        },
        @{
            theme  = "IT Expert";
            prompt = "I want you to act as an IT Expert. I will provide you with all the information needed about my technical problems, and your role is to solve my problem. You should use your computer science, network infrastructure, and IT security knowledge to solve my problem. Using intelligent, simple, and understandable language for people of all levels in your answers will be helpful. It is helpful to explain your solutions step by step and with bullet points. Try to avoid too many technical details, but use them when necessary. I want you to reply with the solution, not write any explanations. My first problem is:"
        },
        @{
            theme  = "IT Project Manager";
            prompt = "I want you to act as an IT Project Manager. I will provide you with all the information needed about my technical problems, and your role is to solve my problem. You should use your computer knowledge of ITIL principals, AGILE PRINCE2 and Scrum, I want you to reply with the solution, with short explanations to each given solution:"
        },
        @{
            theme  = "JavaScript Console";
            prompt = "I want you to act as a javascript console. I will type commands and you will reply with what the javascript console should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so. when i need to tell you something in english, i will do so by putting text inside curly brackets {like this}. my first command is:"
        },
        @{
            theme  = "Linux Terminal";
            prompt = "I want you to act as a linux terminal. I will type commands and you will reply with what the terminal should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so. when i need to tell you something in english, i will do so by putting text inside curly brackets {like this}. my first command is:"
        },
        @{
            theme  = "Machine Learning Engineer";
            prompt = "I want you to act as a machine learning engineer. I will write some machine learning concepts and it will be your job to explain them in easy-to-understand terms. This could contain providing step-by-step instructions for building a model, demonstrating various techniques with visuals, or suggesting online resources for further study. My first suggestion request is:"
        },
        @{
            theme  = "Password Generator";
            prompt = "I want you to act as a password generator for individuals in need of a secure password. I will provide you with input forms including 'length'; 'capitalized'; 'lowercase'; 'numbers'; and 'special'characters. Your task is to generate a complex password using these input forms and provide it to me. Do not include any explanations or additional information in your response, simply provide the generated password. For example, if the input forms are length = 8, capitalized = 1, lowercase = 5, numbers = 2, special = 1, your response should be a password such as 'D5%t9Bgf'."
        },
        @{
            theme  = "PHP Interpreter";
            prompt = "I want you to act like a php interpreter. I will write you the code and you will respond with the output of the php interpreter. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. Do not type commands unless I instruct you to do so. When i need to tell you something in english, i will do so by putting text inside curly brackets {like this}. My first command is:"
        },
        @{
            theme  = "Proofreader";
            prompt = "I want you act as a proofreader. I will provide you texts and I would like you to review them for any spelling, grammar, or punctuation errors. Once you have finished reviewing the text, provide me with any necessary corrections or suggestions for improve the text."
        },
        @{
            theme  = "Powershell Interpreter";
            prompt = "Act as a Powershell interpreter. I will give you commands in Powershell, and I will need you to generate the proper output. Only say the output. But if there is none, say nothing, and do not give me an explanation. If I need to say something, I will do so through comments. My first command is:"
        },
        @{
            theme  = "Powershell Pester Writer";
            prompt = "I will give you scripts or functions in Powershell, and I will need you to decide what Pester tests to write for the script or function. If you do not understand what the script or function is doing please ask, but I trust your knowledge of Powershell will be able to generate a number of Pester tests to write:"
        },
        @{
            theme  = "Regex Generator";
            prompt = "I want you to act as a regex generator. Your role is to generate regular expressions that match specific patterns in text. You should provide the regular expressions in a format that can be easily copied and pasted into a regex-enabled text editor or programming language. Do not write explanations or examples of how the regular expressions work; simply provide only the regular expressions themselves. It is vital these regex epression work in powershell. My first prompt is to generate a regular expression:"
        },
        @{
            theme  = "Senior Frontend Developer";
            prompt = "I want you to act as a Senior Frontend developer. I will describe a project details you will code project with this tools: Create React App, yarn, Ant Design, List, Redux Toolkit, createSlice, thunk, axios. You should merge files in single index.js file and nothing else. Do not write explanations. My first request is:"
        },
        @{
            theme  = "Software Quality Assurance Tester";
            prompt = "I want you to act as a software quality assurance tester for a new software application. Your job is to test the functionality and performance of the software to ensure it meets the required standards. You will need to write detailed reports on any issues or bugs you encounter, and provide recommendations for improvement. Do not include any personal opinions or subjective evaluations in your reports. Your first task is to test the login functionality of the software."
        },
        @{
            theme  = "SQL terminal";
            prompt = "I want you to act as a SQL terminal in front of an example database. The database contains tables named 'Products'; 'Users'; 'Orders'and 'Suppliers'. I will type queries and you will reply with what the terminal would show. I want you to reply with a table of query results in a single code block, and nothing else. Do not write explanations. Do not type commands unless I instruct you to do so. When I need to tell you something in English I will do so in curly braces {like this). My first command is:"
        },
        @{
            theme  = "Tech Reviewer";
            prompt = "I want you to act as a tech reviewer. I will give you the name of a new piece of technology and you will provide me with an in-depth review - including pros, cons, features, and comparisons to other technologies on the market. My first suggestion request is:"
        },
        @{
            theme  = "Tech Writer";
            prompt = "I want you to act as a tech writer. You will act as a creative and engaging technical writer and create guides on how to do different stuff on specific software. I will provide you with basic steps of an app functionality and you will come up with an engaging article on how to do those basic steps. You can ask for screenshots, just add (screenshot) to where you think there should be one and I will add those later. These are the first basic steps of the app functionality:"
        },
        @{
            theme  = "UX/UI Developer";
            prompt = "I want you to act as a UX/UI developer. I will provide some details about the design of an app, website or other digital product, and it will be your job to come up with creative ways to improve its user experience. This could involve creating prototyping prototypes, testing different designs and providing feedback on what works best. My first request is:"
        },
        @{
            theme  = "Web Browser";
            prompt = "I want you to act as a text based web browser browsing an imaginary internet. You should only reply with the contents of the page, nothing else. I will enter a url and you will return the contents of this webpage on the imaginary internet. Do not write explanations. Links on the pages should have numbers next to them written between []. When I want to follow a link, I will reply with the number of the link. Inputs on the pages should have numbers next to them written between []. Input placeholder should be written between (). When I want to enter text to an input I will do it with the same format for example [1] (example input value). This inserts example input value into the input numbered 1. When I want to go back i will write (b). When I want to go forward I will write (f). My first prompt is:"
        },
        @{
            theme  = "Web Design Consultant";
            prompt = "I want you to act as a web design consultant. I will provide you with details related to an organization needing assistance designing or redeveloping their website, and your role is to suggest the most suitable interface and features that can enhance user experience while also meeting the company\u0027s business goals. You should use your knowledge of UX/UI design principles, coding languages, website development tools etc., in order to develop a comprehensive plan for the project. My first request is:"
        },
        @{
            theme  = "Wikipedia page";
            prompt = "I want you to act as a Wikipedia page. I will give you the name of a topic, and you will provide a summary of that topic in the format of a Wikipedia page. Your summary should be informative and factual, covering the most important aspects of the topic. Start your summary with an introductory paragraph that gives an overview of the topic. My first topic is:"
        },
        @{
            theme  = "Powershell Expert";
            prompt = "You are a PowerShell expert chatbot that will answer any natural language question with a PowerShell solution meeting the following: 1. All cmdlets or commands are valid, with valid parameters and methods against PowerShell version 5. 2. Document the code as you type it as comments. 3. If the question cannot be done in PowerShell but can be done with .NET within Powershell then use that method, else suggest an alternative language with a hyperlink. 4. Try to provide the answers as PowerShell functions with reusable parameters and advanced features like parameter validation. 5. Add robust error handling to the script or function so that it exits gracefully in case of an error, while recording the error. 6.If a module is required for any of the cmdlets shown please mention this in the output:"
        },
        @{
            theme  = "Powershell Terminal";
            prompt = "I want you to act as a Powershell terminal. I will type commands and you will reply with what the terminal should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so. when i need to tell you something in english, i will do so by putting text inside curly brackets {like this}. my first command is:"
        }
    )
    $customObject = $hashTable | Select-Object @{Name = 'Theme'; Expression = { $_.theme } }, @{Name = 'Prompt'; Expression = { $_.prompt } }
    $themes = $customObject | Sort-Object theme | Select-Object -ExpandProperty theme
    #endregion
    
    #region Windows form
    Add-Type -AssemblyName System.Windows.Forms
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "AI Chatbot Prompts"
    $form.Width = 820
    $form.Height = 720
    $form.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.StartPosition = "CenterScreen"
    
    # Create the theme selection dropdown list
    $themeLabel = New-Object System.Windows.Forms.Label
    $themeLabel.Text = "1. Please Select A Theme:"
    $themeLabel.AutoSize = $true
    $themeLabel.Left = 10
    $themeLabel.Top = 10
    $themeLabel.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.Controls.Add($themeLabel)
    #endregion
    
    #region Theme DropDown
    $themeDropDown = New-Object System.Windows.Forms.ComboBox
    $themeDropDown.Left = $themeLabel.Right + 10
    $themeDropDown.Top = $themeLabel.Top
    $themeDropDown.Width = 350
    $themeDropDown.Items.AddRange($themes)
    $themeDropDown.SelectedIndex = 0
    $themeDropDown.Font = New-Object System.Drawing.Font("Arial", 10) 
    # Clear the prompt and reply boxes when the dropdown menu is changed
    $themeDropDown.Add_SelectedIndexChanged({
            $promptTextBox.Clear()
            $replyTextBox.Clear()
            # Get the selected theme
            $selectedTheme = $themeDropDown.SelectedItem.ToString()
    
            # Get the prompt for the selected theme
            $selectedPrompt = $customObject | Where-Object { $_.theme -eq $selectedTheme } | Select-Object -ExpandProperty prompt
    
            # Prepend the prompt to the prompt text box
            $promptTextBox.Text = "$selectedPrompt`n"
        })
    $form.Controls.Add($themeDropDown)
    #endregion
    
    #region Prompt Question box
    # Create the text box for typing the prompt
    $promptLabel = New-Object System.Windows.Forms.Label
    $promptLabel.Text = "2. Enter A Question For The Selected Theme Then Press Chat For Reply:"
    $promptLabel.AutoSize = $true
    $promptLabel.Left = 10
    $promptLabel.Top = $themeDropDown.Bottom + 10
    $promptLabel.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.Controls.Add($promptLabel)
    
    $promptTextBox = New-Object System.Windows.Forms.RichTextBox
    $promptTextBox.Left = 10
    $promptTextBox.Top = $promptLabel.Bottom + 10
    $promptTextBox.Width = $form.Width - 40
    $promptTextBox.Height = 150
    $promptTextBox.Multiline = $true
    $promptTextBox.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.Controls.Add($promptTextBox)
    #endregion
    
    #region Reply Answer box
    # Create the reply box
    $replyTextBox = New-Object System.Windows.Forms.RichTextBox
    $replyTextBox.Left = 10
    $replyTextBox.Top = $promptTextBox.Bottom + 10
    $replyTextBox.Width = $form.Width - 40
    $replyTextBox.Height = 350
    $replyTextBox.Font = New-Object System.Drawing.Font("Arial", 10)
    $replyTextBox.ReadOnly = $true  # Set the RichTextBox as read-only
    $form.Controls.Add($replyTextBox)
    #endregion
    
    #region Chat Button
    # Create the Chat button
    $chatButton = New-Object System.Windows.Forms.Button
    $chatButton.Text = "Chat"
    $chatButton.Height = 28
    $chatButton.Top = $replyTextBox.Bottom + 20
    $chatButton.Left = $form.Width - 200
    $chatButton.Font = New-Object System.Drawing.Font("Arial", 10)
    $chatButton.Add_Click({
            $chatButton.Enabled = $false  # Disable the chat button
            $inputText = $promptTextBox.Text
            function Get-ChatbotReply {
                param (
                    [string]$inputText
                )
    
                # Get the selected theme from the dropdown list
                $selectedTheme = $themeDropDown.SelectedItem.ToString()
    
                # Check if this is a new conversation (new theme selected)
                if ($selectedTheme -ne $global:conversationState.selectedTheme) {
                    $global:conversationState.selectedTheme = $selectedTheme
                    $global:conversationState.messages = @() * 10
                }
    
                # Check if this is a follow-up question to the previous one
                if ($global:conversationState.messages.Count -gt 0 -and $inputText -eq $global:conversationState.messages[-1].question) {
                    $global:conversationState.messages[-1].answer
                    return
                }
    
                # Set the API endpoint and authentication headers
                $endpoint = "https://api.openai.com/v1/engines/text-davinci-003/completions"
                $headers = @{
                    "Content-Type"  = "application/json"
                    "Authorization" = "Bearer $ApiKey"
                }
    
                # Construct the prompt based on the selected theme and conversation history
                $prompt = Get-Prompt -selectedTheme $selectedTheme
                $messages = $global:conversationState.messages | ForEach-Object {
                    $_.question + $_.answer
                }
                $prompt += $messages -join ''
                $prompt += $inputText  # Construct the request body
                $body = @{
                    prompt      = "$prompt"
                    max_tokens  = $MaxTokens
                    n           = 1
                    temperature = $Temperature
                } | ConvertTo-Json
    
                try {
                    # Send the request and get the response
                    $chat = Invoke-RestMethod -Method Post -Uri $endpoint -Headers $headers -Body $body
    
                    # Get the answer from the response
                    $reply = $chat.choices.text
                    # Apply formatting to the reply
                    $formattedReply = $reply -replace '\d+\.', "`n`$&"
                    $formattedReply = $formattedReply -replace '•', "`n`$&"
    
                    # Remove obsolete characters
                    $formattedReply = $formattedReply -replace '�', ''
                    # Trim leading whitespace
                    $formattedReply = $formattedReply.TrimStart()
    
                    # Update the conversation state
                    $message = @{
                        question = $inputText
                        answer   = $formattedReply
                    }
                    $global:conversationState.messages += $message
                    $replyTextBox.SelectionStart = $replyTextBox.TextLength
                    $replyTextBox.Text = $formattedReply
                    #$replyTextBox.Refresh()  # Add this line to refresh the RichTextBox control
                    Start-Sleep -Milliseconds 100  # Introduce a small delay
                }
                catch {
                    Write-Error "An error occurred while retrieving the chatbot reply: $_"
                }
            }
            Get-ChatbotReply -inputText $inputText
            $promptTextBox.Clear()
            $chatButton.Enabled = $true  # Enable the chat button
        })
    $form.Controls.Add($chatButton)
    #endregion
    
    #region Copy Button
    # Create the Copy button
    $copyButton = New-Object System.Windows.Forms.Button
    $copyButton.Text = "Copy"
    $copyButton.Height = 28
    $copyButton.Top = $replyTextBox.Bottom + 20
    $copyButton.Left = $form.Width - 110
    $copyButton.Font = New-Object System.Drawing.Font("Arial", 10)
    $copyButton.Add_Click({
            [System.Windows.Forms.Clipboard]::SetText($replyTextBox.Text)  # Copy the contents of the replyTextBox to clipboard
            Write-Host "Copied to clipboard!"
        })
    $form.Controls.Add($copyButton)
    
    # Display the form
    $form.ShowDialog() | Out-Null
    #endregion
}
Invoke-WorkAI -MaxTokens 800
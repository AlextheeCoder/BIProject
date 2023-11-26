<?php

// Database connection details
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "startup_predictions"; // Replace with your database name

// Check if the form data is available
if (isset($_GET['funding_total_usd']) && isset($_GET['funding_rounds']) && isset($_GET['milestones']) && isset($_GET['category_code']) && isset($_GET['state']) && isset($_GET['industry'])) {
    // API endpoint URL
    $apiUrl = 'http://127.0.0.1:5022/predict_startup';

    // Retrieve the parameters from the form submission
    $params = array(
        'funding_total_usd' => $_GET['funding_total_usd'],
        'funding_rounds' => $_GET['funding_rounds'],
        'milestones' => $_GET['milestones'],
        'category_code' => $_GET['category_code'],
        'state' => $_GET['state'],
        'industry' => $_GET['industry']
    );

    // Initialize cURL session
    $curl = curl_init();

    // Set cURL options
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $apiUrl = $apiUrl . '?' . http_build_query($params);
    curl_setopt($curl, CURLOPT_URL, $apiUrl);

    // Execute the GET request
    $response = curl_exec($curl);

    // Check for cURL errors
    if (curl_errno($curl)) {
        $error = curl_error($curl);
        curl_close($curl);
        die("cURL Error: $error");
    }

    // Close the cURL session
    curl_close($curl);

    // Decode the JSON response
    $data = json_decode($response, true);

    // Display the prediction
    if (isset($data[0])) {
        $prediction_result = $data[0];
        echo "The predicted status is: " . $prediction_result . "<br>";

        // Create database connection
        $conn = new mysqli($servername, $username, $password, $dbname);

        // Check database connection
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Prepare and bind
        $stmt = $conn->prepare("INSERT INTO predictions (funding_total_usd, funding_rounds, milestones, category_code, state, industry, prediction_result) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("diissss", $params['funding_total_usd'], $params['funding_rounds'], $params['milestones'], $params['category_code'], $params['state'], $params['industry'], $prediction_result);

        // Execute the statement
        $stmt->execute();

        // Close statement and connection
        $stmt->close();
        $conn->close();

    } else {
        echo "API Error: " . $data['message'];
    }
} else {
    echo "Please provide all required inputs.";
}

?>

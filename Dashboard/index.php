<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KPI Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  </head>
  <style>
    .predict-button{
      margin: 20px;
    }
    .predict-button a{
          background-color: #007bff;
          color: white;
          padding: 10px;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          text-decoration: none;
    }

  </style>
  <body>
    <!-- The bootstrap 5 tutorial is available here: https://www.w3schools.com/bootstrap5/index.php 
    and here:https://getbootstrap.com/docs/5.0/getting-started/introduction/ -->
    <!-- The Chart JS manual is available here: https://www.chartjs.org/docs/latest/charts/area.html -->
    <div class="row">
      <div class="col-md-2 bg-light bg-gradient">
        <h1>Business-Facing Analytics Dashboard</h1>
        <div style="color:#354E9D">
          <strong>BBT4106 and BBT4206: Business Intelligence Project<br /></strong>
          <strong><br />Name:<br />Alex Mwai Muthee</strong>
          <strong>Student ID:<br />131123</strong>
        </div>
        <br />
        <strong>Kaplan and Norton’s Balanced Scorecard</strong>
        <br>
        <div class="predict-button">
        <a href="predict.php">Predict</a>
        </div>
        
      </div>
      <div class="col-md-10 row">
  <!-- Start of Key Metrics -->
  <?php
  function humanize_number($input){
    $input = number_format($input);
    $input_count = substr_count($input, ',');
    if($input_count != '0'){
        if($input_count == '1'){
            return substr($input, 0, -4).'K';
        } else if($input_count == '2'){
            return substr($input, 0, -8).'M';
        } else if($input_count == '3'){
            return substr($input, 0,  -12).'B';
        } else {
            return;
        }
    } else {
        return $input;
    }
  }
  ?>
<?php
include 'dbconfig.php';

// Create database connection
$conn = new mysqli($dbservername, $dbusername, $dbpassword, $dbname);

// Check database connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch KPI 1: Total Number of Predictions
$query1 = "SELECT COUNT(*) AS total_predictions FROM predictions";
$result1 = $conn->query($query1);
$row1 = $result1->fetch_assoc();
$totalPredictions = $row1['total_predictions'];

// Fetch KPI 2: Most Common Prediction Outcome
$query2 = "SELECT 
              CASE 
                WHEN prediction_result = 1 THEN 'Success' 
                ELSE 'Fail' 
              END AS prediction_outcome, 
              COUNT(*) AS count 
           FROM predictions 
           GROUP BY prediction_outcome 
           ORDER BY count DESC 
           LIMIT 1";
$result2 = $conn->query($query2);
$row2 = $result2->fetch_assoc();
$mostCommonPredictionOutcome = $row2['prediction_outcome'];


// Fetch KPI 3: Top Industry or Category
$query3 = "SELECT category_code, COUNT(*) AS count FROM predictions GROUP BY category_code ORDER BY count DESC LIMIT 1";
$result3 = $conn->query($query3);
$row3 = $result3->fetch_assoc();
$topIndustry = $row3['category_code'];

// Fetch KPI 4: Region with Most Predictions
$query4 = "SELECT state, COUNT(*) AS count FROM predictions GROUP BY state ORDER BY count DESC LIMIT 1";
$result4 = $conn->query($query4);
$row4 = $result4->fetch_assoc();
$topRegion = $row4['state'];

$conn->close();
?>



  <div class="col-md-3 my-1">
        <div class="card">
            <div class="card-body text-center">
              <strong>Total Predictions</strong><hr>
              <h1><?php echo $totalPredictions; ?></h1>
            </div>
        </div>
  </div>
  <div class="col-md-3 my-1">
        <div class="card">
            <div class="card-body text-center">
              <strong>Most Common Outcome</strong><hr>
              <h1><?php echo $mostCommonPredictionOutcome; ?></h1>
            </div>
        </div>
  </div>
  <div class="col-md-3 my-1">
        <div class="card">
            <div class="card-body text-center">
              <strong>Top Industry</strong><hr>
              <h1><?php echo $topIndustry; ?></h1>
            </div>
        </div>
  </div>
  <div class="col-md-3 my-1">
        <div class="card">
            <div class="card-body text-center">
              <strong>Top Region</strong><hr>
              <h1><?php echo $topRegion; ?></h1>
            </div>
        </div>
  </div>
  <!-- End of Key Metrics -->

    <!-- Start of KPI DIVs -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <?php include 'kpi1.php'; ?> 
    <?php include 'kpi2.php'; ?>
    <?php include 'kpi3.php'; ?>
    <?php include 'kpi4.php'; ?>
    <!-- End of KPI DIVs -->
  </body>
</html>
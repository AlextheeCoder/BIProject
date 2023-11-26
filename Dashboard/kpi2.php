<?php
include 'dbconfig.php';

// Create database connection
$conn = new mysqli($dbservername, $dbusername, $dbpassword, $dbname);

// Check database connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query for historical distribution of predictions
$historicalDistributionQuery = "SELECT 
    CASE 
        WHEN prediction_result = 1 THEN 'Success' 
        ELSE 'Fail' 
    END AS prediction_outcome, 
    COUNT(*) AS count 
FROM predictions 
GROUP BY prediction_outcome";
$historicalDistributionResult = $conn->query($historicalDistributionQuery);

$historicalDistribution = [];
while($row = $historicalDistributionResult->fetch_assoc()) {
    $historicalDistribution[] = $row;
}

// Query for recent distribution of predictions (e.g., last 6 months)
$recentDistributionQuery = "SELECT 
    CASE 
        WHEN prediction_result = 1 THEN 'Success' 
        ELSE 'Fail' 
    END AS prediction_outcome, 
    COUNT(*) AS count 
FROM predictions 
WHERE prediction_time > DATE_SUB(NOW(), INTERVAL 1 MONTH) 
GROUP BY prediction_outcome";
$recentDistributionResult = $conn->query($recentDistributionQuery);

$recentDistribution = [];
while($row = $recentDistributionResult->fetch_assoc()) {
    $recentDistribution[] = $row;
}

$conn->close();
?>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI2a (Lagging): Historical Distribution of Predictions</strong>
            <canvas id="KPI2a"></canvas>
        </div>
    </div>
</div>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI2b (Leading): Recent Distribution of Predictions</strong>
            <canvas id="KPI2b"></canvas>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    var ctx1 = document.getElementById('KPI2a').getContext('2d');
    var chart1 = new Chart(ctx1, {
        type: 'pie',
        data: {
            labels: <?php echo json_encode(array_column($historicalDistribution, 'prediction_outcome')); ?>,
            datasets: [{
                label: 'Historical Predictions',
                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                data: <?php echo json_encode(array_column($historicalDistribution, 'count')); ?>
            }]
        },
        options: {}
    });

    var ctx2 = document.getElementById('KPI2b').getContext('2d');
    var chart2 = new Chart(ctx2, {
        type: 'doughnut',
        data: {
            labels: <?php echo json_encode(array_column($recentDistribution, 'prediction_outcome')); ?>,
            datasets: [{
                label: 'Recent Predictions',
                backgroundColor: ['rgb(255, 99, 132)',
              'rgb(54, 162, 235)',
              'rgb(255, 205, 86)'],
                data: <?php echo json_encode(array_column($recentDistribution, 'count')); ?>
            }]
        },
        options: {}
    });
</script>

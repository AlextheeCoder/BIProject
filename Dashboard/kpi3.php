<?php
include 'dbconfig.php';

// Create database connection
$conn = new mysqli($dbservername, $dbusername, $dbpassword, $dbname);

// Check database connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query for historical count of predictions by category
$historicalCategoryQuery = "SELECT category_code, COUNT(*) AS count FROM predictions GROUP BY category_code";
$historicalCategoryResult = $conn->query($historicalCategoryQuery);

$historicalCategoryData = [];
while($row = $historicalCategoryResult->fetch_assoc()) {
    $historicalCategoryData[] = $row;
}

// Query for recent count of predictions by category (e.g., last 6 months)
$recentCategoryQuery = "SELECT category_code, COUNT(*) AS count FROM predictions WHERE prediction_time > DATE_SUB(NOW(), INTERVAL 1 MONTH) GROUP BY category_code";
$recentCategoryResult = $conn->query($recentCategoryQuery);

$recentCategoryData = [];
while($row = $recentCategoryResult->fetch_assoc()) {
    $recentCategoryData[] = $row;
}

$conn->close();
?>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI3a (Lagging): Historical Count of Predictions by Category</strong>
            <canvas id="KPI3a"></canvas>
        </div>
    </div>
</div>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI3b (Leading): Recent Count of Predictions by Category</strong>
            <canvas id="KPI3b"></canvas>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    var ctx3a = document.getElementById('KPI3a').getContext('2d');
    var chart3a = new Chart(ctx3a, {
        type: 'bar',
        data: {
            labels: <?php echo json_encode(array_column($historicalCategoryData, 'category_code')); ?>,
            datasets: [{
                label: 'Historical Predictions by Category',
                backgroundColor: 'rgba(78, 115, 223, 0.5)',
                borderColor: 'rgba(78, 115, 223, 1)',
                data: <?php echo json_encode(array_column($historicalCategoryData, 'count')); ?>
            }]
        },
        options: {}
    });

    var ctx3b = document.getElementById('KPI3b').getContext('2d');
    var chart3b = new Chart(ctx3b, {
        type: 'bar',
        data: {
            labels: <?php echo json_encode(array_column($recentCategoryData, 'category_code')); ?>,
            datasets: [{
                label: 'Recent Predictions by Category',
                backgroundColor: ['rgb(255, 99, 132)',
              'rgb(54, 162, 235)',
              'rgb(255, 205, 86)'],
                borderColor: 'rgba(28, 200, 138, 1)',
                data: <?php echo json_encode(array_column($recentCategoryData, 'count')); ?>
            }]
        },
        options: {}
    });
</script>

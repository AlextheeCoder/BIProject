<?php
include 'dbconfig.php';

// Create database connection
$conn = new mysqli($dbservername, $dbusername, $dbpassword, $dbname);

// Check database connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query for historical geographical distribution of predictions
$historicalGeographicalQuery = "SELECT state, COUNT(*) AS count FROM predictions GROUP BY state";
$historicalGeographicalResult = $conn->query($historicalGeographicalQuery);

$historicalGeographicalData = [];
while($row = $historicalGeographicalResult->fetch_assoc()) {
    $historicalGeographicalData[] = $row;
}

// Query for recent geographical distribution of predictions (e.g., last 6 months)
$recentGeographicalQuery = "SELECT state, COUNT(*) AS count FROM predictions WHERE prediction_time > DATE_SUB(NOW(), INTERVAL 6 MONTH) GROUP BY state";
$recentGeographicalResult = $conn->query($recentGeographicalQuery);

$recentGeographicalData = [];
while($row = $recentGeographicalResult->fetch_assoc()) {
    $recentGeographicalData[] = $row;
}

$conn->close();
?>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI4a (Lagging): Historical Geographical Distribution of Predictions</strong>
            <canvas id="KPI4a"></canvas>
        </div>
    </div>
</div>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI4b (Leading): Recent Geographical Distribution of Predictions</strong>
            <canvas id="KPI4b"></canvas>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    var ctx4a = document.getElementById('KPI4a').getContext('2d');
    var chart4a = new Chart(ctx4a, {
        type: 'bar',
        data: {
            labels: <?php echo json_encode(array_column($historicalGeographicalData, 'state')); ?>,
            datasets: [{
                label: 'Historical Predictions by State',
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                borderColor: 'rgba(255, 99, 132, 1)',
                data: <?php echo json_encode(array_column($historicalGeographicalData, 'count')); ?>
            }]
        },
        options: {}
    });

    var ctx4b = document.getElementById('KPI4b').getContext('2d');
    var chart4b = new Chart(ctx4b, {
        type: 'bar',
        data: {
            labels: <?php echo json_encode(array_column($recentGeographicalData, 'state')); ?>,
            datasets: [{
                label: 'Recent Predictions by State',
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                borderColor: 'rgba(54, 162, 235, 1)',
                data: <?php echo json_encode(array_column($recentGeographicalData, 'count')); ?>
            }]
        },
        options: {}
    });
</script>

<?php
include 'dbconfig.php';

// Create database connection
$conn = new mysqli($dbservername, $dbusername, $dbpassword, $dbname);

// Check database connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query for total number of predictions made
$totalPredictionsQuery = "SELECT COUNT(*) AS total_predictions FROM predictions";
$totalPredictionsResult = $conn->query($totalPredictionsQuery);
$totalPredictions = $totalPredictionsResult->fetch_assoc()['total_predictions'];

// Query for rate of new predictions (example: monthly)
// Query for rate of new predictions (daily)
$rateOfPredictionsQuery = "SELECT DATE(prediction_time) AS day, COUNT(*) AS count FROM predictions GROUP BY day ORDER BY day";
$rateOfPredictionsResult = $conn->query($rateOfPredictionsQuery);

$predictionsByDay = [];
while($row = $rateOfPredictionsResult->fetch_assoc()) {
    $predictionsByDay[] = $row;
}


$conn->close();
?>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI1a (Leading): Total number of predictions made to date</strong>
            <p><?php echo $totalPredictions; ?></p>
        </div>
    </div>
</div>

<div class="col-md-6 my-1">
    <div class="card">
        <div class="card-body text-center">
            <strong>KPI1b (Lagging): Rate of new predictions being made</strong>
            <canvas id="KPI1b"></canvas>
        </div>
    </div>
</div>

<script>
    var ctx = document.getElementById('KPI1b').getContext('2d');
    var chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: <?php echo json_encode(array_column($predictionsByDay, 'day')); ?>,
            datasets: [{
                label: 'Daily Predictions',
                backgroundColor: 'rgba(0, 123, 255, 0.1)',
                borderColor: 'rgb(0, 123, 255)',
                data: <?php echo json_encode(array_column($predictionsByDay, 'count')); ?>
            }]
        },
        options: {
            scales: {
                xAxes: [{
                    type: 'time',
                    time: {
                        unit: 'day',
                        tooltipFormat: 'MMM DD, YYYY',
                        displayFormats: {
                            day: 'MMM DD'
                        }
                    }
                }]
            }
        }
    });
</script>
// MEXIFY Core Logic & Interactions
document.addEventListener('DOMContentLoaded', () => {
    // Initialize AOS
    //AOS.init({
    //    duration: 800,
    //    easing: 'ease-out-cubic',
    //    once: true,
    //    offset: 50
    //});

    // =========================================
    // ROI CALCULATOR LOGIC
    // =========================================
    const calcAmount = document.getElementById('calcAmount');
    const calcPlan = document.getElementById('calcPlan');
    const resultProfit = document.getElementById('resultProfit');
    const resultTotal = document.getElementById('resultTotal');
    const roiChartCtx = document.getElementById('roiChart');
    let roiChart;

    function calculateROI() {
        const amount = parseFloat(calcAmount.value) || 0;
        const selectedOption = calcPlan.options[calcPlan.selectedIndex];
        const dailyRate = parseFloat(selectedOption.value) / 100;
        const days = parseInt(selectedOption.dataset.days);

        const dailyProfit = amount * dailyRate;
        const totalProfit = dailyProfit * days;
        const totalPayout = amount + totalProfit;

        // Format Currency
        const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

        // Animate Numbers
        animateValue(resultProfit, formatter.format(0), formatter.format(totalProfit), 1000);
        animateValue(resultTotal, formatter.format(0), formatter.format(totalPayout), 1000);

        // Update Chart
        updateChart(amount, dailyProfit, days);
    }

    function animateValue(obj, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            obj.innerHTML = end; // Simplified for currency formatting
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    function updateChart(principal, dailyProfit, days) {
        const labels = [];
        const data = [];
        const steps = Math.min(days, 10); // Show max 10 points for clean UI
        const stepSize = Math.floor(days / steps);

        for (let i = 0; i <= steps; i++) {
            const currentDay = i * stepSize;
            labels.push(`Day ${currentDay}`);
            data.push(principal + (dailyProfit * currentDay));
        }

        if (roiChart) roiChart.destroy();

        roiChart = new Chart(roiChartCtx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Portfolio Value',
                    data: data,
                    borderColor: '#00D4FF',
                    backgroundColor: 'rgba(0, 212, 255, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 6,
                    pointHoverBackgroundColor: '#00FFB2'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(11, 19, 43, 0.9)',
                        borderColor: '#00D4FF',
                        borderWidth: 1,
                        titleColor: '#fff',
                        bodyColor: '#A0AABF',
                        padding: 12,
                        displayColors: false
                    }
                },
                scales: {
                    y: {
                        grid: { color: 'rgba(255,255,255,0.05)', drawBorder: false },
                        ticks: { color: '#6B758D', callback: (val) => '$' + val.toLocaleString() }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#6B758D' }
                    }
                }
            }
        });
    }

    // Event Listeners
    if (calcAmount) calcAmount.addEventListener('input', calculateROI);
    if (calcPlan) calcPlan.addEventListener('change', calculateROI);

    // Initial Calc
    if (calcAmount && calcPlan) calculateROI();
});
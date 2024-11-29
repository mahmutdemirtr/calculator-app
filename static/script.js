const display = document.getElementById("display");
const buttons = document.querySelectorAll(".buttons button");

let currentInput = "";

buttons.forEach(button => {
  button.addEventListener("click", async () => {
    const value = button.textContent;

    if (!isNaN(value) || value === ".") {
      currentInput += value;
      display.value = currentInput;
    } else if (value === "C") {
      currentInput = "";
      display.value = "";
    } else if (value === "=") {
      try {
        const response = await fetch("/calculate", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({ expression: currentInput })
        });
        const data = await response.json();
        if (data.result !== undefined) {
          display.value = data.result;
          currentInput = data.result.toString();
        } else {
          display.value = "Error";
        }
      } catch (error) {
        display.value = "Error";
      }
    } else {
      currentInput += ` ${value} `;
      display.value = currentInput;
    }
  });
});

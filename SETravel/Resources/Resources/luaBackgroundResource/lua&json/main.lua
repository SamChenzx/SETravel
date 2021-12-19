require('textArea')
require('extraArea')


function drawBackground(canvas, session)
    
    saveState(canvas)
    translate(canvas, 0, 24)
    drawTextArea(canvas, session)
    restoreState(canvas)
    
    drawExtraArea(canvas, session)
    
end





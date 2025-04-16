import { app, shell, BrowserWindow, ipcMain, dialog } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import connectDB from './db'

const SQL_QUERIES = {
  GET_PARTNERS: `SELECT T1.*,
    CASE WHEN sum(T2.QUANTITY) > 300000 THEN 15
    WHEN sum(T2.QUANTITY) > 50000 THEN 10
    WHEN sum(T2.QUANTITY) > 10000 THEN 5
    ELSE 0 
    END as discount
    from PARTNERS as T1
    LEFT JOIN SALES as T2 on T1.ID = T2.PARTNER_ID
    GROUP BY T1.ID, T1.ORGANIZATION_TYPE, T1.NAME, T1.CEO, T1.EMAIL, T1.PHONE, T1.ADDRESS, T1.TAXPAYER_ID, T1.RATING`,

  CREATE_PARTNER: `INSERT into PARTNERS (organization_type, name, ceo, email, phone, address, rating) 
    values($1, $2, $3, $4, $5, $6, $7)`,

  UPDATE_PARTNER: `UPDATE PARTNERS
    SET name = $1, organization_type = $2, ceo = $3, email = $4, 
    phone = $5, address = $6, rating = $7
    WHERE id = $8`
}

async function getPartners() {
  try {
    const response = await global.dbclient.query(SQL_QUERIES.GET_PARTNERS)
    return response.rows
  } catch (error) {
    console.error('Error fetching partners:', error)
    throw new Error('Failed to fetch partners')
  }
}

async function createPartner(event, partner) {
  const { type, name, ceo, email, phone, address, rating } = partner

  try {
    await global.dbclient.query(SQL_QUERIES.CREATE_PARTNER, [
      type, name, ceo, email, phone, address, rating
    ])
    dialog.showMessageBox({ message: 'Успех! Партнер создан' })
  } catch (error) {
    console.error('Error creating partner:', error)
    if (error.code === '23505') { // Unique violation
      dialog.showErrorBox('Ошибка', 'Партнер с таким именем уже существует')
    } else {
      dialog.showErrorBox('Ошибка', 'Не удалось создать партнера')
    }
  }
}

async function updatePartner(event, partner) {
  const { id, type, name, ceo, email, phone, address, rating } = partner

  try {
    await global.dbclient.query(SQL_QUERIES.UPDATE_PARTNER, [
      name, type, ceo, email, phone, address, rating, id
    ])
    dialog.showMessageBox({ message: 'Успех! Данные обновлены' })
  } catch (error) {
    console.error('Error updating partner:', error)
    if (error.code === '23505') { // Unique violation
      dialog.showErrorBox('Ошибка', 'Партнер с таким именем уже существует')
    } else {
      dialog.showErrorBox('Ошибка', 'Не удалось обновить данные партнера')
    }
  }
}

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 900,
    height: 750,
    show: false,
    autoHideMenuBar: true,
    ...(process.platform === 'linux' 
      ? { icon: join(__dirname, '../../resources/Мастер пол.png') } 
      : { icon: join(__dirname, '../../resources/Мастер пол.ico') }),
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false
    }
  })

  mainWindow.on('ready-to-show', () => {
    mainWindow.show()
  })

  mainWindow.webContents.setWindowOpenHandler((details) => {
    shell.openExternal(details.url)
    return { action: 'deny' }
  })

  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }
}

app.whenReady().then(async () => {
  try {
    electronApp.setAppUserModelId('com.electron')
    global.dbclient = await connectDB()

    ipcMain.handle('getPartners', getPartners)
    ipcMain.handle('createPartner', createPartner)
    ipcMain.handle('updatePartner', updatePartner)

    app.on('browser-window-created', (_, window) => {
      optimizer.watchWindowShortcuts(window)
    })

    createWindow()

    app.on('activate', function () {
      if (BrowserWindow.getAllWindows().length === 0) createWindow()
    })
  } catch (error) {
    console.error('Failed to initialize application:', error)
    app.quit()
  }
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

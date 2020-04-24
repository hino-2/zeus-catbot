const TelegramBot = require('node-telegram-bot-api')
const Agent       = require('socks5-https-client/lib/Agent')
// const config      = require('config')
const fs          = require('fs')
const dotenv      = require('dotenv')

dotenv.config()

process.env["NTBA_FIX_350"] = 1

// const token = config.get('token')
const token = process.env.token

const hozyain  = 407927900
const natasha  = 229793471
let isFighting = false
const replies  = [
  'Мяу', 'Мур', 'Муур', 'Мууур', 'Муурр', 'Муррр', 'Мурмяу', 'Пф', 'Ме', 'Миу', 'Мееу', 
  'Муа', 'Апчхи', 'Фуррр', 'Ммууууууррррмяяяяу', 'Мяу?', 'Мяу!', 'Мявк', 'Мявк!', 'Есть хочу'
]

console.log('Began myan at', new Date().toString())

const bot = new TelegramBot(token, {
  onlyFirstMatch: true,
  polling: {
    interval: 1000,
    autoStart: true
  },
  // request: {
	// 	agentClass: Agent,
	// 	agentOptions: {
	// 		socksHost: process.env.proxy_host,
	// 		socksPort: process.env.proxy_port,
	// 		// socksUsername: config.get('proxy_login'),
	// 		// socksPassword: config.get('proxy_pass')
	// 	}
	// }
})

bot.onText(/передай:\s(.+)/, (msg, match) => {
  bot.sendMessage(natasha, match[1])
})

bot.onText(/(.+)/, (msg, match) => {
  let reply
  let photo
  let doc
  let chatId = msg.chat.id

  if (isFighting && msg.from.id === natasha)  
    reply = 'Я с тобой не разговариваю'
  else 
    switch (true) {

      case /поссорился с женой/i.test(match[1]):
        if(msg.from.id === hozyain) {
          isFighting = true
          reply = 'Я на твоей стороне, хозяин! =^.^= !!'
        }
        break

      case /помирился с женой/i.test(match[1]):
        if(msg.from.id === hozyain) {
          isFighting = false
          reply = 'Я тоже по ней соскучился мяу (('
        }
        break

      case /красив|красав/i.test(match[1]):
        reply = 'красивый'
        break

      case /привет|здравс|здраст/i.test(match[1]):
        reply = 'Ну привет'
        photo = 'https://pp.userapi.com/c621515/v621515627/11c6f/YTQ9NOBOxwk.jpg'
        break

      case /пират|pirat/i.test(match[1]):
        reply = 'Йарр!!'
        photo = '/var/home/ushakov.i.s/progs/telegram-bot/pirat.png'
        break

      case /выключ|прослед/i.test(match[1]):
        reply = 'Мя прослежу.'
        break

      case /позвонить ветеринару/i.test(match[1]):
        reply = 'Вот телемяфон: Ника +7 (343) 210–43–46 или Ветпульс +7 (343) 200–08–04'
        break

      case /команды|что (|ты )умеешь/i.test(match[1]):
        reply = "1. позвонить ветеринару - телефон спасения котиков\n2. покажи [пред[пред[пред[пред[пред[...]]]]]последние анализы - котик помнит все свои анализы и с радостью поделится этой информацией с хозяинами"
        break

      case /покажи(.*)(а|мя)нализ(|ы|ов)/i.test(match[1]):
        if(![hozyain, natasha].includes(msg.from.id)) {
          reply = 'Тебе не покажу! ТАЙМНЯЯЯЯЯЯ!!!! ШШШШШШШШШШШ!'
          break
        }

        files = fs.readdirSync('analizy')
        reply = 'Мя помню ' + files.length + ' штук мянализов. ' +
                'Мягу показать последние, или предпоследние, ' +
                'или предпредпоследние, или ... мянализы. Или список.'

        if(/список/i.test(match[1])) 
          reply = files.join('\n')

        if(/последние/i.test(match[1])) {
          let num = [...match[1].matchAll(/пред/gi)].length
          reply = `Вот мяи ${new Array(num).fill('пред').join('')}последние мянализы (тшшшш это вмячебная таймня)`
          if(/pdf|doc|odt/.test(files[files.length-num-1])) 
            doc = `analizy/${files[files.length-num-1]}`
          else 
            photo = `analizy/${files[files.length-num-1]}`
        }
        break

      case /c\/d|мкб|мочекамен/i.test(match[1]):
        reply = 'Это мой любимый c/d, ОМГ !!! https://www.petshop.ru/catalog/cats/syxkor/vzroslye_1_6let/c_d_dlya_koshek_profilaktika_mkb_okean_ryba_1089/'
        break

      case /k\/d|почек|почеч|почки/i.test(match[1]):
        reply = 'Это мой любимый k/d, ОМГ !!! https://www.petshop.ru/catalog/cats/syxkor/vzroslye_1_6let/k_d_dlya_koshek_lechenie_pochek_serdca_i_nizhnego_otdel_mochevyvod_putey_1094/'
        break

      case /еда|есть|куша|корм|жрат/i.test(match[1]):
        reply = 'МЯУ!'
        photo = 'https://pp.userapi.com/c621515/v621515877/e6a5/JYpGfWh5Jew.jpg'
        break

      default:
        reply = replies[Math.floor(Math.random() * replies.length)]
        break
    }
  
  console.log(`message: ${chatId}:${msg.from.first_name} ${msg.from.last_name}:${msg.from.username}:${match[1]}`)

  if(reply)
    bot.sendMessage(chatId, reply)
       .catch((error) => {
         console.log(error.response.body)
    });
  if(doc)
    bot.sendDocument(chatId, fs.readFileSync(doc), {}, {
      filename: doc
    }).catch((error) => {
      console.log(error.response.body)
    });
  if(photo) 
    bot.sendPhoto(chatId, ( /^http/.test(photo) ? photo : fs.readFileSync(photo)))
       .catch((error) => {
         console.log(error.response.body)
    })
})

bot.on('polling_error', (error) => {
  console.log(error);  
});

const fiveToSevenDays = () => 
  432000000 + Math.floor(Math.random() * 172800000)

const samMyauknul = () => {
  bot.sendMessage(natasha, replies[Math.floor(Math.random() * replies.length)])
  setTimeout(() => {
    samMyauknul()
  }, fiveToSevenDays())
}

setTimeout(() => {
  samMyauknul()
}, fiveToSevenDays())